Return-Path: <SRS0=qYOK=Z7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195C2C43603
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Dec 2019 19:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E340C20692
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Dec 2019 19:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLITIl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:08:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:25524 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfLITIl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 9 Dec 2019 14:08:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 11:08:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="210202854"
Received: from nshalmon-mobl.ger.corp.intel.com (HELO localhost) ([10.252.8.146])
  by fmsmga008.fm.intel.com with ESMTP; 09 Dec 2019 11:08:31 -0800
Date:   Mon, 9 Dec 2019 21:08:29 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v24 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191209182219.GA19243@linux.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-13-jarkko.sakkinen@linux.intel.com>
 <op.0b6gvhtiwjvjmi@hhuan26-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0b6gvhtiwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 02, 2019 at 09:48:43AM -0600, Haitao Huang wrote:
> On Fri, 29 Nov 2019 17:13:14 -0600, Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> 
> 
> > +
> > +	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > +		if (signal_pending(current)) {
> > +			ret = -ERESTARTSYS;
> > +			break;
> > +		}
> 
> This IOC is not idempotent as pages EADDed at this point can not be
> re-EADDed again. So we can't return ERESTARTSYS

Agreed, should be -EINTR.

I added these entries to the v25 change log based on your recent
reports:

* Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
  fails on executing ENCLS[EADD]. The rollback path executed
  radix_tree_delete() on the same address twice when this happened.
  [fixes v24, reported by Haitao]
* Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES when
  a signal is pending [fixes v23, reported by Haitao]

The master branch [1] has been updated accordingly. There is also a
tag v24 for looking up easily what has overally changed e.g.

$ git --no-pager diff v24..master
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ab9e48cd294b..5c9e6e161698 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -413,13 +413,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
 				  src);
-	if (ret) {
-		/* ENCLS failure. */
-		if (ret == -EIO)
-			sgx_encl_destroy(encl);
-
+	if (ret)
 		goto err_out;
-	}
 
 	/*
 	 * Complete the "add" before doing the "extend" so that the "add"
@@ -432,17 +427,11 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 
 	if (flags & SGX_PAGE_MEASURE) {
 		ret = __sgx_encl_extend(encl, epc_page);
-
-		/* ENCLS failure. */
-		if (ret) {
-			sgx_encl_destroy(encl);
-			goto out_unlock;
-		}
+		if (ret)
+			goto err_out;
 	}
 
 	sgx_mark_page_reclaimable(encl_page->epc_page);
-
-out_unlock:
 	mutex_unlock(&encl->lock);
 	up_read(&current->mm->mmap_sem);
 	return ret;
@@ -460,6 +449,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	sgx_free_page(epc_page);
 	kfree(encl_page);
 
+	/*
+	 * Destroy enclave on ENCLS failure as this means that EPC has been
+	 * invalidated.
+	 */
+	if (ret == -EIO)
+		sgx_encl_destroy(encl);
+
 	return ret;
 }
 
@@ -536,7 +532,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 
 	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
 		if (signal_pending(current)) {
-			ret = -ERESTARTSYS;
+			ret = -EINTR;
 			break;
 		}

[1] https://github.com/jsakkine-intel/linux-sgx

/Jarkko
