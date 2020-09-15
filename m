Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38486C2D0E3
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C652076B
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="cdJRGQTx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgIPAtI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIOLlj (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Sep 2020 07:41:39 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B49C061351;
        Tue, 15 Sep 2020 04:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kyKBxcBJt11qcWFCIP3GMwrWxClKNYEvGsza00xEyNI=; b=cdJRGQTxiT4O10zs2TKVdKg16w
        zq5d+G1i0W75d6lh78kL9gtnYbsS6n8wO93L7wKZSJOb9oG68HPXfI5xdHfXc5bys8hhqoWEAfd4a
        OKiUPfjc9GvjV4EgMfihsXg12TtA1tlXYj8z68Q46UdReAeZbHwMOIxDGfpmc2rFGZeSKY5IjRKl8
        YJT9yotArwKQNHgMqXokfawdDTGhL8wFLMo4rt74vsifY5tLENURoB6Ya7ix3KRtkkRS+gw+HCYz7
        ret+td+6wKupDYgYjhrOeHo23n+X53aMgDGTn7h9iLDKvzLoc5dNkIhqwXi8+jg3xYsZYdXczQHUN
        YhJAG1yQ==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1kI8mF-0005yQ-5l; Tue, 15 Sep 2020 14:05:35 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver
Date:   Tue, 15 Sep 2020 14:05:15 +0300
Message-Id: <20200915110522.893152-18-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add VMA callbacks for ptrace() that can be used with debug enclaves.
With debug enclaves data can be read and write the memory word at a time
by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.

Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 87 ++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 11ec2df59b54..7f8df2c8ef35 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -333,10 +333,97 @@ static int sgx_vma_mprotect(struct vm_area_struct *vma,
 	return mprotect_fixup(vma, pprev, start, end, newflags);
 }
 
+static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset = addr & ~PAGE_MASK;
+	int ret;
+
+
+	ret = __edbgrd(sgx_get_epc_addr(page->epc_page) + offset, data);
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset = addr & ~PAGE_MASK;
+	int ret;
+
+	ret = __edbgwr(sgx_get_epc_addr(page->epc_page) + offset, data);
+	if (ret)
+		return -EIO;
+
+	return 0;
+}
+
+static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
+			  void *buf, int len, int write)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry = NULL;
+	char data[sizeof(unsigned long)];
+	unsigned long align;
+	unsigned int flags;
+	int offset;
+	int cnt;
+	int ret = 0;
+	int i;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return -EFAULT;
+
+	flags = atomic_read(&encl->flags);
+
+	if (!(flags & SGX_ENCL_DEBUG) || !(flags & SGX_ENCL_INITIALIZED) ||
+	    (flags & SGX_ENCL_DEAD))
+		return -EFAULT;
+
+	for (i = 0; i < len; i += cnt) {
+		entry = sgx_encl_reserve_page(encl, (addr + i) & PAGE_MASK);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			break;
+		}
+
+		align = ALIGN_DOWN(addr + i, sizeof(unsigned long));
+		offset = (addr + i) & (sizeof(unsigned long) - 1);
+		cnt = sizeof(unsigned long) - offset;
+		cnt = min(cnt, len - i);
+
+		ret = sgx_edbgrd(encl, entry, align, data);
+		if (ret)
+			goto out;
+
+		if (write) {
+			memcpy(data + offset, buf + i, cnt);
+			ret = sgx_edbgwr(encl, entry, align, data);
+			if (ret)
+				goto out;
+		} else
+			memcpy(buf + i, data + offset, cnt);
+
+out:
+		mutex_unlock(&encl->lock);
+
+		if (ret)
+			break;
+	}
+
+	return ret < 0 ? ret : i;
+}
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.open = sgx_vma_open,
 	.fault = sgx_vma_fault,
 	.mprotect = sgx_vma_mprotect,
+	.access = sgx_vma_access,
 };
 
 /**
-- 
2.25.1

