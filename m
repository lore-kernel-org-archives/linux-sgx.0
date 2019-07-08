Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B81C606C2
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 16:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC91821479
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 16:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="F4Yv5iEp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfGHQ0a (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 12:26:30 -0400
Received: from sonic311-30.consmr.mail.gq1.yahoo.com ([98.137.65.211]:34252
        "EHLO sonic311-30.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728420AbfGHQ0a (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 Jul 2019 12:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1562603186; bh=BsLiV64kEcKa1zPIWDZmEIyl2+hvkmJvie4xmXkFPhI=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=F4Yv5iEpVIwA9DgT3x6JM0NkipDWxTxqMWD9GlfIp2Jecsunr3WPK05yFsWhsw/SFJeD3NfccCa6myRhnSUw+kWkrS6mruiyLJZmfkcm+IcnYnBZNh+4OruJO/QVHRSBbZXxo2asv+mma4XJnhafvwuzwKBvt2Jos2fChApNPiRgnVG7G/POwVDTRPPNUDajEpfMIx87ftJZK3gZifY7eG6/e3NoXBjr4RAzFVUa093PBoqhjDacovV32L9ZiOs8zs+pVpft4KDedbnNXsOI6RoJ60nStFu9G2nXRN0cLZMZb6zRbV1TwqC6cvmFhS36QBzdSjZR3bbh9Qg/Lth3Lw==
X-YMail-OSG: DhJVIGoVM1kdSyGieJY7hww8Zv91xX3VnM_nFvOZQb_kzpX1JT5KNdGEvLvkEY_
 Or8WaLcWQqr4sUIKV0a1xiFnP6TwIBNwOZy5WFPIVWMEpYEubBX.tYeQZ8XACxe8onuWRjbp4ybo
 y9RNY_kSzyf1iYiaFnK1WzWIJqXK5myO2xDqGks0pvCpkmB75ZTvgJTDxXflsz_bknoMF0a84xb3
 i27Vklcrfe.xr2ODbzVyqqdrlK1jRleZN6vfaLGr4CZCAkA99nEou4Zo4haiRwo4lUrlHN.7.MAi
 LKbDqbDUAsrV3IQN6Yvflrzka5IfTQfizHdlAr6IwB40Mi7_c3cKmg3kazQ6BF3iPkCacIGwj6dp
 w2pwSx5UrcjY7tWtuz5QeukbdJWFtU6upt9Z8b_SBIP_KWJI14kipMSvFlHVxi.rNJP3hlyAaiUS
 0CpPkbZMHa9EnscCmiIUp7Ac2uiThGiVkmcMZnbwZ60CaJYmjd7YnmE1_dgvYV7xf.LJGHbJqPKG
 1Fxtj1rKrlpK8nLSu9PP5Ia7R9zXtB_azCNHwcJ380mZvE0N6hNBrFXWqrAI.n36zxjyh3DmTLLS
 zLJAW.8RHjbzErJ8hnQXIQcDRuxObytZeLBGj0euFfyKmwAFjU8VKD11.NhtRcZAWAblLWxjPWx_
 cgaoTdWdq0KD1RGQXd.cCoZb12Es8.Rf7nT0UyL0rllU1N8qMAP_zGqxqGD89fQNC.rVGn2C_rqd
 nbTK8aMRrED1vKYiGaXjiayCHznP7vZA185p2.Mt5gBS0QUR3_45pBRBkDHUvt0l71Rwjjm8A4TY
 tEa16oPVtSGL4eESALd.UsE8qDsuxJs2z2CAtWG5v_AsUw719n2tDlxmiE0W4gSSrgbw5a6W.Sz2
 TqTnEbmztr.An0s5XIZyWs2hv1MREOxhGIhN7GOiHZqDpijgxvslzDzAiedGnMbZMkD68TOV1pp5
 Br5lmwEdBQW8AjSOQjmHz0eYGInWPB3AEZBNVlFOAIGKjaRhibCB.bGJbWtUUjF3eDPkl_VtYjhi
 8PyhCqYI5Z8d.A2D4BYy9M7j3OEuhRIKiB.sqsBiy60SmmmyJBzAkr38D888rsPPIa0WYzmHFfvs
 lRzYgGYYIT7XeW0dLKqHhtxyGwMPGLHsxi82EzUEOhY.VwhektWubSvxR6Pt7pSoM8Wj6jYeraaM
 TRDjtt0JduS3.i7I0CFZkskVDqx6sST9EMkZO6Bkj7xoRDrmVXRRvwbGFSnz5TEGRBPGTRq4oSfg
 8pSqKQb.cwbg6Ly1jmrnAFmcx
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.gq1.yahoo.com with HTTP; Mon, 8 Jul 2019 16:26:26 +0000
Received: by smtp416.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 0be9e5867a7705fab07a983afa80a70d;
          Mon, 08 Jul 2019 16:26:23 +0000 (UTC)
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
Date:   Mon, 8 Jul 2019 09:26:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/7/2019 4:41 PM, Cedric Xing wrote:
> As enclave pages have different lifespan than the existing MAP_PRIVATE =
and
> MAP_SHARED pages, a new data structure is required outside of VMA to tr=
ack
> their protections and/or origins. Enclave Memory Area (or EMA for short=
) has
> been introduced to address the need. EMAs are maintained by a new LSM m=
odule
> named =E2=80=9Cema=E2=80=9D, which is similar to the idea of the =E2=80=
=9Ccapability=E2=80=9D LSM module.

First off, I'll say that this is an improvement over
the LSM integrated version that preceded it. I still
have some issues with the naming, but I'll address that
inline. I do have a suggestion that I think will make
this more conventional.

In this scheme you use an ema LSM to manage your ema data.
A quick sketch looks like:

	sgx_something_in() calls
		security_enclave_load() calls
			ema_enclave_load()
			selinux_enclave_load()
			otherlsm_enclave_load()

Why is this better than:

	sgx_something_in() calls
		ema_enclave_load()
		security_enclave_load() calls
			selinux_enclave_load()
			otherlsm_enclave_load()


If you did really want ema to behave like an LSM
you would put the file data that SELinux is managing
into the ema portion of the blob and provide interfaces
for the SELinux (or whoever) to use that. Also, it's
an abomination (as I've stated before) for ema to
rely on SELinux to provide a file_free() hook for
ema's data. If you continue down the LSM route, you
need to provide an ema_file_free() hook. You can't
count on SELinux to do it for you. If there are multiple
LSMs (coming soon!) that use the ema data, they'll all
try to free it, and then Bad Things can happen.

>
> This new =E2=80=9Cema=E2=80=9D module has LSM_ORDER_FIRST so will alway=
s be dispatched before
> other LSM_ORDER_MUTABLE modules (e.g. selinux, apparmor, etc.). It is
> responsible for initializing EMA maps, and inserting and freeing EMA no=
des, and
> offers APIs for other LSM modules to query/update EMAs. Details could b=
e found
> in include/linux/lsm_ema.h and security/commonema.c.
>
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
> ---
>  include/linux/lsm_ema.h |  97 ++++++++++++++

I still think this should be enclave.h (or commonema.h)
as it is not LSM code.

>  security/Makefile       |   1 +
>  security/commonema.c    | 277 ++++++++++++++++++++++++++++++++++++++++=

>  3 files changed, 375 insertions(+)
>  create mode 100644 include/linux/lsm_ema.h
>  create mode 100644 security/commonema.c
>
> diff --git a/include/linux/lsm_ema.h b/include/linux/lsm_ema.h
> new file mode 100644
> index 000000000000..59fc4ea6fa78
> --- /dev/null
> +++ b/include/linux/lsm_ema.h
> @@ -0,0 +1,97 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> + * Enclave Memory Area interface for LSM modules
> + *
> + * Copyright(c) 2016-19 Intel Corporation.
> + */
> +
> +#ifndef _LSM_EMA_H_
> +#define _LSM_EMA_H_
> +
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +
> +/**
> + * ema - Enclave Memory Area structure for LSM modules

LSM modules is redundant. "LSM" or "LSMs" would be better.

> + *
> + * Data structure to track origins of enclave pages
> + *
> + * @link:
> + *	Link to adjacent EMAs. EMAs are sorted by their addresses in ascend=
ing
> + *	order
> + * @start:
> + *	Starting address
> + * @end:
> + *	Ending address
> + * @source:
> + *	File from which this range was loaded from, or NULL if not loaded f=
rom
> + *	any files
> + */
> +struct ema {
> +	struct list_head	link;
> +	size_t			start;
> +	size_t			end;
> +	struct file		*source;
> +};
> +
> +#define ema_data(ema, offset)	\
> +	((void *)((char *)((struct ema *)(ema) + 1) + offset))
> +
> +/**
> + * ema_map - LSM Enclave Memory Map structure for LSM modules

As above.

> + *
> + * Container for EMAs of an enclave
> + *
> + * @list:
> + *	Head of a list of sorted EMAs
> + * @lock:
> + *	Acquire before querying/updateing the list EMAs
> + */
> +struct ema_map {
> +	struct list_head	list;
> +	struct mutex		lock;
> +};
> +
> +size_t __init ema_request_blob(size_t blob_size);
> +struct ema_map *ema_get_map(struct file *encl);
> +int ema_apply_to_range(struct ema_map *map, size_t start, size_t end,
> +		       int (*cb)(struct ema *ema, void *arg), void *arg);
> +void ema_remove_range(struct ema_map *map, size_t start, size_t end);
> +
> +static inline int __must_check ema_lock_map(struct ema_map *map)
> +{
> +	return mutex_lock_interruptible(&map->lock);
> +}
> +
> +static inline void ema_unlock_map(struct ema_map *map)
> +{
> +	mutex_unlock(&map->lock);
> +}
> +
> +static inline int ema_lock_apply_to_range(struct ema_map *map,
> +					  size_t start, size_t end,
> +					  int (*cb)(struct ema *, void *),
> +					  void *arg)
> +{
> +	int rc =3D ema_lock_map(map);
> +	if (!rc) {
> +		rc =3D ema_apply_to_range(map, start, end, cb, arg);
> +		ema_unlock_map(map);
> +	}
> +	return rc;
> +}
> +
> +static inline int ema_lock_remove_range(struct ema_map *map,
> +					size_t start, size_t end)
> +{
> +	int rc =3D ema_lock_map(map);
> +	if (!rc) {
> +		ema_remove_range(map, start, end);
> +		ema_unlock_map(map);
> +	}
> +	return rc;
> +}
> +
> +#endif /* _LSM_EMA_H_ */
> diff --git a/security/Makefile b/security/Makefile
> index c598b904938f..b66d03a94853 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_SECURITY_YAMA)		+=3D yama/
>  obj-$(CONFIG_SECURITY_LOADPIN)		+=3D loadpin/
>  obj-$(CONFIG_SECURITY_SAFESETID)       +=3D safesetid/
>  obj-$(CONFIG_CGROUP_DEVICE)		+=3D device_cgroup.o
> +obj-$(CONFIG_INTEL_SGX)			+=3D commonema.o

The config option and the file name ought to match,
or at least be closer.

> =20
>  # Object integrity file lists
>  subdir-$(CONFIG_INTEGRITY)		+=3D integrity
> diff --git a/security/commonema.c b/security/commonema.c

Put this in a subdirectory. Please.

> new file mode 100644
> index 000000000000..c5b0bdfdc013
> --- /dev/null
> +++ b/security/commonema.c
> @@ -0,0 +1,277 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
> +// Copyright(c) 2016-18 Intel Corporation.
> +
> +#include <linux/lsm_ema.h>
> +#include <linux/lsm_hooks.h>
> +#include <linux/slab.h>
> +
> +static struct kmem_cache *_map_cache;
> +static struct kmem_cache *_node_cache;
> +static size_t _data_size __lsm_ro_after_init;
> +
> +static struct lsm_blob_sizes ema_blob_sizes __lsm_ro_after_init =3D {
> +	.lbs_file =3D sizeof(atomic_long_t),
> +};

If this is ema's data ema must manage it. You *must* have
a file_free().

> +
> +static atomic_long_t *_map_file(struct file *encl)
> +{
> +	return (void *)((char *)(encl->f_security) + ema_blob_sizes.lbs_file)=
;

I don't trust all the casting going on here, especially since
you don't end up with the type you should be returning.

> +}
> +
> +static struct ema_map *_alloc_map(void)

Function header comments, please.

> +{
> +	struct ema_map *m;
> +
> +	m =3D kmem_cache_zalloc(_map_cache, GFP_KERNEL);
> +	if (likely(m)) {
> +		INIT_LIST_HEAD(&m->list);
> +		mutex_init(&m->lock);
> +	}
> +	return m;
> +}
> +
> +static struct ema *_new_ema(size_t start, size_t end, struct file *src=
)
> +{
> +	struct ema *ema;
> +
> +	if (unlikely(!_node_cache)) {
> +		struct kmem_cache *c;
> +
> +		c =3D kmem_cache_create("lsm-ema", sizeof(*ema) + _data_size,
> +				      __alignof__(typeof(*ema)), SLAB_PANIC,
> +				      NULL);
> +		if (atomic_long_cmpxchg((atomic_long_t *)&_node_cache, 0,
> +					(long)c))
> +			kmem_cache_destroy(c);
> +	}
> +
> +	ema =3D kmem_cache_zalloc(_node_cache, GFP_KERNEL);
> +	if (likely(ema)) {
> +		INIT_LIST_HEAD(&ema->link);
> +		ema->start =3D start;
> +		ema->end =3D end;
> +		if (src)
> +			ema->source =3D get_file(src);
> +	}
> +	return ema;
> +}
> +
> +static void _free_ema(struct ema *ema)
> +{
> +	if (ema->source)
> +		fput(ema->source);
> +	kmem_cache_free(_node_cache, ema);
> +}
> +
> +static void _free_map(struct ema_map *map)
> +{
> +	struct ema *p, *n;
> +
> +	WARN_ON(mutex_is_locked(&map->lock));
> +	list_for_each_entry_safe(p, n, &map->list, link)
> +		_free_ema(p);
> +	kmem_cache_free(_map_cache, map);
> +}
> +
> +static struct ema_map *_init_map(struct file *encl)
> +{
> +	struct ema_map *m =3D ema_get_map(encl);
> +	if (!m) {
> +		m =3D _alloc_map();
> +		if (atomic_long_cmpxchg(_map_file(encl), 0, (long)m)) {
> +			_free_map(m);
> +			m =3D ema_get_map(encl);
> +		}
> +	}
> +	return m;
> +}
> +
> +static inline struct ema *_next_ema(struct ema *p, struct ema_map *map=
)
> +{
> +	p =3D list_next_entry(p, link);
> +	return &p->link =3D=3D &map->list ? NULL : p;
> +}
> +
> +static inline struct ema *_find_ema(struct ema_map *map, size_t a)
> +{
> +	struct ema *p;
> +
> +	WARN_ON(!mutex_is_locked(&map->lock));
> +
> +	list_for_each_entry(p, &map->list, link)
> +		if (a < p->end)
> +			break;
> +	return &p->link =3D=3D &map->list ? NULL : p;
> +}
> +
> +static struct ema *_split_ema(struct ema *p, size_t at)
> +{
> +	typeof(p) n;
> +
> +	if (at <=3D p->start || at >=3D p->end)
> +		return p;
> +
> +	n =3D _new_ema(p->start, at, p->source);
> +	if (likely(n)) {
> +		memcpy(n + 1, p + 1, _data_size);
> +		p->start =3D at;
> +		list_add_tail(&n->link, &p->link);
> +	}
> +	return n;
> +}
> +
> +static int _merge_ema(struct ema *p, struct ema_map *map)
> +{
> +	typeof(p) prev =3D list_prev_entry(p, link);
> +
> +	WARN_ON(!mutex_is_locked(&map->lock));
> +
> +	if (&prev->link =3D=3D &map->list || prev->end !=3D p->start ||
> +	    prev->source !=3D p->source || memcmp(prev + 1, p + 1, _data_size=
))
> +		return 0;
> +
> +	p->start =3D prev->start;
> +	fput(prev->source);
> +	_free_ema(prev);
> +	return 1;
> +}
> +
> +static inline int _insert_ema(struct ema_map *map, struct ema *n)
> +{
> +	typeof(n) p =3D _find_ema(map, n->start);
> +
> +	if (!p)
> +		list_add_tail(&n->link, &map->list);
> +	else if (n->end <=3D p->start)
> +		list_add_tail(&n->link, &p->link);
> +	else
> +		return -EEXIST;
> +
> +	_merge_ema(n, map);
> +	if (p)
> +		_merge_ema(p, map);
> +	return 0;
> +}
> +
> +static void ema_file_free_security(struct file *encl)
> +{
> +	struct ema_map *m =3D ema_get_map(encl);
> +	if (m)
> +		_free_map(m);
> +}
> +
> +static int ema_enclave_load(struct file *encl, size_t start, size_t en=
d,
> +			    size_t flags, struct vm_area_struct *vma)
> +{
> +	struct ema_map *m;
> +	struct ema *ema;
> +	int rc;
> +
> +	m =3D _init_map(encl);
> +	if (unlikely(!m))
> +		return -ENOMEM;
> +
> +	ema =3D _new_ema(start, end, vma ? vma->vm_file : NULL);
> +	if (unlikely(!ema))
> +		return -ENOMEM;
> +
> +	rc =3D ema_lock_map(m);
> +	if (!rc) {
> +		rc =3D _insert_ema(m, ema);
> +		ema_unlock_map(m);
> +	}
> +	if (rc)
> +		_free_ema(ema);
> +	return rc;
> +}
> +
> +static int ema_enclave_init(struct file *encl, struct sgx_sigstruct *s=
igstruct,
> +			    struct vm_area_struct *vma)
> +{
> +	if (unlikely(!_init_map(encl)))
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static struct security_hook_list ema_hooks[] __lsm_ro_after_init =3D {=

> +	LSM_HOOK_INIT(file_free_security, ema_file_free_security),
> +	LSM_HOOK_INIT(enclave_load, ema_enclave_load),
> +	LSM_HOOK_INIT(enclave_init, ema_enclave_init),
> +};
> +
> +static int __init ema_init(void)
> +{
> +	_map_cache =3D kmem_cache_create("lsm-ema_map", sizeof(struct ema_map=
),
> +				       __alignof__(struct ema_map), SLAB_PANIC,
> +				       NULL);
> +	security_add_hooks(ema_hooks, ARRAY_SIZE(ema_hooks), "ema");
> +	return 0;
> +}
> +
> +DEFINE_LSM(ema) =3D {
> +	.name =3D "ema",
> +	.order =3D LSM_ORDER_FIRST,
> +	.init =3D ema_init,
> +	.blobs =3D &ema_blob_sizes,
> +};
> +
> +/* ema_request_blob shall only be called from LSM module init function=
 */
> +size_t __init ema_request_blob(size_t size)
> +{
> +	typeof(_data_size) offset =3D _data_size;
> +	_data_size +=3D size;
> +	return offset;
> +}
> +
> +struct ema_map *ema_get_map(struct file *encl)
> +{
> +	return (struct ema_map *)atomic_long_read(_map_file(encl));
> +}
> +
> +/**
> + * Invoke a callback function on every EMA falls within range, split E=
MAs as
> + * needed
> + */
> +int ema_apply_to_range(struct ema_map *map, size_t start, size_t end,
> +		       int (*cb)(struct ema *, void *), void *arg)
> +{
> +	struct ema *ema;
> +	int rc;
> +
> +	ema =3D _find_ema(map, start);
> +	while (ema && end > ema->start) {
> +		if (start > ema->start)
> +			_split_ema(ema, start);
> +		if (end < ema->end)
> +			ema =3D _split_ema(ema, end);
> +
> +		rc =3D (*cb)(ema, arg);
> +		_merge_ema(ema, map);
> +		if (rc)
> +			return rc;
> +
> +		ema =3D _next_ema(ema, map);
> +	}
> +
> +	if (ema)
> +		_merge_ema(ema, map);
> +	return 0;
> +}
> +
> +/* Remove all EMAs falling within range, split EMAs as needed */
> +void ema_remove_range(struct ema_map *map, size_t start, size_t end)
> +{
> +	struct ema *ema, *n;
> +
> +	ema =3D _find_ema(map, start);
> +	while (ema && end > ema->start) {
> +		if (start > ema->start)
> +			_split_ema(ema, start);
> +		if (end < ema->end)
> +			ema =3D _split_ema(ema, end);
> +
> +		n =3D _next_ema(ema, map);
> +		_free_ema(ema);
> +		ema =3D n;
> +	}
> +}

