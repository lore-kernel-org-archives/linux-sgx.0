Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3CAC61087
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E0D92064B
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 23:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfGGXlt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 19:41:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:62277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbfGGXls (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 19:41:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 16:41:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,464,1557212400"; 
   d="scan'208";a="340295313"
Received: from bxing-mobl.amr.corp.intel.com (HELO ubt18m.amr.corp.intel.com) ([10.251.135.59])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2019 16:41:46 -0700
From:   Cedric Xing <cedric.xing@intel.com>
To:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, cedric.xing@intel.com
Subject: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
Date:   Sun,  7 Jul 2019 16:41:33 -0700
Message-Id: <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1562542383.git.cedric.xing@intel.com>
References: <cover.1562542383.git.cedric.xing@intel.com>
In-Reply-To: <cover.1562542383.git.cedric.xing@intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com> <cover.1562542383.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

As enclave pages have different lifespan than the existing MAP_PRIVATE and
MAP_SHARED pages, a new data structure is required outside of VMA to track
their protections and/or origins. Enclave Memory Area (or EMA for short) has
been introduced to address the need. EMAs are maintained by a new LSM module
named “ema”, which is similar to the idea of the “capability” LSM module.

This new “ema” module has LSM_ORDER_FIRST so will always be dispatched before
other LSM_ORDER_MUTABLE modules (e.g. selinux, apparmor, etc.). It is
responsible for initializing EMA maps, and inserting and freeing EMA nodes, and
offers APIs for other LSM modules to query/update EMAs. Details could be found
in include/linux/lsm_ema.h and security/commonema.c.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
---
 include/linux/lsm_ema.h |  97 ++++++++++++++
 security/Makefile       |   1 +
 security/commonema.c    | 277 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 375 insertions(+)
 create mode 100644 include/linux/lsm_ema.h
 create mode 100644 security/commonema.c

diff --git a/include/linux/lsm_ema.h b/include/linux/lsm_ema.h
new file mode 100644
index 000000000000..59fc4ea6fa78
--- /dev/null
+++ b/include/linux/lsm_ema.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/**
+ * Enclave Memory Area interface for LSM modules
+ *
+ * Copyright(c) 2016-19 Intel Corporation.
+ */
+
+#ifndef _LSM_EMA_H_
+#define _LSM_EMA_H_
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+
+/**
+ * ema - Enclave Memory Area structure for LSM modules
+ *
+ * Data structure to track origins of enclave pages
+ *
+ * @link:
+ *	Link to adjacent EMAs. EMAs are sorted by their addresses in ascending
+ *	order
+ * @start:
+ *	Starting address
+ * @end:
+ *	Ending address
+ * @source:
+ *	File from which this range was loaded from, or NULL if not loaded from
+ *	any files
+ */
+struct ema {
+	struct list_head	link;
+	size_t			start;
+	size_t			end;
+	struct file		*source;
+};
+
+#define ema_data(ema, offset)	\
+	((void *)((char *)((struct ema *)(ema) + 1) + offset))
+
+/**
+ * ema_map - LSM Enclave Memory Map structure for LSM modules
+ *
+ * Container for EMAs of an enclave
+ *
+ * @list:
+ *	Head of a list of sorted EMAs
+ * @lock:
+ *	Acquire before querying/updateing the list EMAs
+ */
+struct ema_map {
+	struct list_head	list;
+	struct mutex		lock;
+};
+
+size_t __init ema_request_blob(size_t blob_size);
+struct ema_map *ema_get_map(struct file *encl);
+int ema_apply_to_range(struct ema_map *map, size_t start, size_t end,
+		       int (*cb)(struct ema *ema, void *arg), void *arg);
+void ema_remove_range(struct ema_map *map, size_t start, size_t end);
+
+static inline int __must_check ema_lock_map(struct ema_map *map)
+{
+	return mutex_lock_interruptible(&map->lock);
+}
+
+static inline void ema_unlock_map(struct ema_map *map)
+{
+	mutex_unlock(&map->lock);
+}
+
+static inline int ema_lock_apply_to_range(struct ema_map *map,
+					  size_t start, size_t end,
+					  int (*cb)(struct ema *, void *),
+					  void *arg)
+{
+	int rc = ema_lock_map(map);
+	if (!rc) {
+		rc = ema_apply_to_range(map, start, end, cb, arg);
+		ema_unlock_map(map);
+	}
+	return rc;
+}
+
+static inline int ema_lock_remove_range(struct ema_map *map,
+					size_t start, size_t end)
+{
+	int rc = ema_lock_map(map);
+	if (!rc) {
+		ema_remove_range(map, start, end);
+		ema_unlock_map(map);
+	}
+	return rc;
+}
+
+#endif /* _LSM_EMA_H_ */
diff --git a/security/Makefile b/security/Makefile
index c598b904938f..b66d03a94853 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
 obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_INTEL_SGX)			+= commonema.o
 
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
diff --git a/security/commonema.c b/security/commonema.c
new file mode 100644
index 000000000000..c5b0bdfdc013
--- /dev/null
+++ b/security/commonema.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/lsm_ema.h>
+#include <linux/lsm_hooks.h>
+#include <linux/slab.h>
+
+static struct kmem_cache *_map_cache;
+static struct kmem_cache *_node_cache;
+static size_t _data_size __lsm_ro_after_init;
+
+static struct lsm_blob_sizes ema_blob_sizes __lsm_ro_after_init = {
+	.lbs_file = sizeof(atomic_long_t),
+};
+
+static atomic_long_t *_map_file(struct file *encl)
+{
+	return (void *)((char *)(encl->f_security) + ema_blob_sizes.lbs_file);
+}
+
+static struct ema_map *_alloc_map(void)
+{
+	struct ema_map *m;
+
+	m = kmem_cache_zalloc(_map_cache, GFP_KERNEL);
+	if (likely(m)) {
+		INIT_LIST_HEAD(&m->list);
+		mutex_init(&m->lock);
+	}
+	return m;
+}
+
+static struct ema *_new_ema(size_t start, size_t end, struct file *src)
+{
+	struct ema *ema;
+
+	if (unlikely(!_node_cache)) {
+		struct kmem_cache *c;
+
+		c = kmem_cache_create("lsm-ema", sizeof(*ema) + _data_size,
+				      __alignof__(typeof(*ema)), SLAB_PANIC,
+				      NULL);
+		if (atomic_long_cmpxchg((atomic_long_t *)&_node_cache, 0,
+					(long)c))
+			kmem_cache_destroy(c);
+	}
+
+	ema = kmem_cache_zalloc(_node_cache, GFP_KERNEL);
+	if (likely(ema)) {
+		INIT_LIST_HEAD(&ema->link);
+		ema->start = start;
+		ema->end = end;
+		if (src)
+			ema->source = get_file(src);
+	}
+	return ema;
+}
+
+static void _free_ema(struct ema *ema)
+{
+	if (ema->source)
+		fput(ema->source);
+	kmem_cache_free(_node_cache, ema);
+}
+
+static void _free_map(struct ema_map *map)
+{
+	struct ema *p, *n;
+
+	WARN_ON(mutex_is_locked(&map->lock));
+	list_for_each_entry_safe(p, n, &map->list, link)
+		_free_ema(p);
+	kmem_cache_free(_map_cache, map);
+}
+
+static struct ema_map *_init_map(struct file *encl)
+{
+	struct ema_map *m = ema_get_map(encl);
+	if (!m) {
+		m = _alloc_map();
+		if (atomic_long_cmpxchg(_map_file(encl), 0, (long)m)) {
+			_free_map(m);
+			m = ema_get_map(encl);
+		}
+	}
+	return m;
+}
+
+static inline struct ema *_next_ema(struct ema *p, struct ema_map *map)
+{
+	p = list_next_entry(p, link);
+	return &p->link == &map->list ? NULL : p;
+}
+
+static inline struct ema *_find_ema(struct ema_map *map, size_t a)
+{
+	struct ema *p;
+
+	WARN_ON(!mutex_is_locked(&map->lock));
+
+	list_for_each_entry(p, &map->list, link)
+		if (a < p->end)
+			break;
+	return &p->link == &map->list ? NULL : p;
+}
+
+static struct ema *_split_ema(struct ema *p, size_t at)
+{
+	typeof(p) n;
+
+	if (at <= p->start || at >= p->end)
+		return p;
+
+	n = _new_ema(p->start, at, p->source);
+	if (likely(n)) {
+		memcpy(n + 1, p + 1, _data_size);
+		p->start = at;
+		list_add_tail(&n->link, &p->link);
+	}
+	return n;
+}
+
+static int _merge_ema(struct ema *p, struct ema_map *map)
+{
+	typeof(p) prev = list_prev_entry(p, link);
+
+	WARN_ON(!mutex_is_locked(&map->lock));
+
+	if (&prev->link == &map->list || prev->end != p->start ||
+	    prev->source != p->source || memcmp(prev + 1, p + 1, _data_size))
+		return 0;
+
+	p->start = prev->start;
+	fput(prev->source);
+	_free_ema(prev);
+	return 1;
+}
+
+static inline int _insert_ema(struct ema_map *map, struct ema *n)
+{
+	typeof(n) p = _find_ema(map, n->start);
+
+	if (!p)
+		list_add_tail(&n->link, &map->list);
+	else if (n->end <= p->start)
+		list_add_tail(&n->link, &p->link);
+	else
+		return -EEXIST;
+
+	_merge_ema(n, map);
+	if (p)
+		_merge_ema(p, map);
+	return 0;
+}
+
+static void ema_file_free_security(struct file *encl)
+{
+	struct ema_map *m = ema_get_map(encl);
+	if (m)
+		_free_map(m);
+}
+
+static int ema_enclave_load(struct file *encl, size_t start, size_t end,
+			    size_t flags, struct vm_area_struct *vma)
+{
+	struct ema_map *m;
+	struct ema *ema;
+	int rc;
+
+	m = _init_map(encl);
+	if (unlikely(!m))
+		return -ENOMEM;
+
+	ema = _new_ema(start, end, vma ? vma->vm_file : NULL);
+	if (unlikely(!ema))
+		return -ENOMEM;
+
+	rc = ema_lock_map(m);
+	if (!rc) {
+		rc = _insert_ema(m, ema);
+		ema_unlock_map(m);
+	}
+	if (rc)
+		_free_ema(ema);
+	return rc;
+}
+
+static int ema_enclave_init(struct file *encl, struct sgx_sigstruct *sigstruct,
+			    struct vm_area_struct *vma)
+{
+	if (unlikely(!_init_map(encl)))
+		return -ENOMEM;
+	return 0;
+}
+
+static struct security_hook_list ema_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(file_free_security, ema_file_free_security),
+	LSM_HOOK_INIT(enclave_load, ema_enclave_load),
+	LSM_HOOK_INIT(enclave_init, ema_enclave_init),
+};
+
+static int __init ema_init(void)
+{
+	_map_cache = kmem_cache_create("lsm-ema_map", sizeof(struct ema_map),
+				       __alignof__(struct ema_map), SLAB_PANIC,
+				       NULL);
+	security_add_hooks(ema_hooks, ARRAY_SIZE(ema_hooks), "ema");
+	return 0;
+}
+
+DEFINE_LSM(ema) = {
+	.name = "ema",
+	.order = LSM_ORDER_FIRST,
+	.init = ema_init,
+	.blobs = &ema_blob_sizes,
+};
+
+/* ema_request_blob shall only be called from LSM module init function */
+size_t __init ema_request_blob(size_t size)
+{
+	typeof(_data_size) offset = _data_size;
+	_data_size += size;
+	return offset;
+}
+
+struct ema_map *ema_get_map(struct file *encl)
+{
+	return (struct ema_map *)atomic_long_read(_map_file(encl));
+}
+
+/**
+ * Invoke a callback function on every EMA falls within range, split EMAs as
+ * needed
+ */
+int ema_apply_to_range(struct ema_map *map, size_t start, size_t end,
+		       int (*cb)(struct ema *, void *), void *arg)
+{
+	struct ema *ema;
+	int rc;
+
+	ema = _find_ema(map, start);
+	while (ema && end > ema->start) {
+		if (start > ema->start)
+			_split_ema(ema, start);
+		if (end < ema->end)
+			ema = _split_ema(ema, end);
+
+		rc = (*cb)(ema, arg);
+		_merge_ema(ema, map);
+		if (rc)
+			return rc;
+
+		ema = _next_ema(ema, map);
+	}
+
+	if (ema)
+		_merge_ema(ema, map);
+	return 0;
+}
+
+/* Remove all EMAs falling within range, split EMAs as needed */
+void ema_remove_range(struct ema_map *map, size_t start, size_t end)
+{
+	struct ema *ema, *n;
+
+	ema = _find_ema(map, start);
+	while (ema && end > ema->start) {
+		if (start > ema->start)
+			_split_ema(ema, start);
+		if (end < ema->end)
+			ema = _split_ema(ema, end);
+
+		n = _next_ema(ema, map);
+		_free_ema(ema);
+		ema = n;
+	}
+}
-- 
2.17.1

