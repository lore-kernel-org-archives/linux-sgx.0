Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69239C31E40
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D502085A
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391122AbfFJQVw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:21:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:38265 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388996AbfFJQVw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 12:21:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 09:21:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 10 Jun 2019 09:21:50 -0700
Date:   Mon, 10 Jun 2019 09:21:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v2 4/5] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Message-ID: <20190610162150.GD15995@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-5-sean.j.christopherson@intel.com>
 <5706a7ec-5497-c560-92fa-91c9751b9096@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5706a7ec-5497-c560-92fa-91c9751b9096@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 07, 2019 at 03:58:34PM -0400, Stephen Smalley wrote:
> On 6/5/19 10:11 PM, Sean Christopherson wrote:
> >enclave_load() is roughly analogous to the existing file_mprotect().
> >
> >Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> >VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> >MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> >VMAs.  As a result, the existing/standard call to file_mprotect() does
> >not provide any meaningful security for enclaves since an LSM can only
> >deny/grant access to the EPC as a whole.
> >
> >security_enclave_load() is called when SGX is first loading an enclave
> >page, i.e. copying a page from normal memory into the EPC.  Although
> >the prototype for enclave_load() is similar to file_mprotect(), e.g.
> >SGX could theoretically use file_mprotect() and set reqprot=prot, a
> >separate hook is desirable as the semantics of an enclave's protection
> >bits are different than those of vmas, e.g. an enclave page tracks the
> >maximal set of protections, whereas file_mprotect() operates on the
> >actual protections being provided.  In other words, LSMs will likely
> >want to implement different policies for enclave page protections.
> >
> >Note, extensive discussion yielded no sane alternative to some form of
> >SGX specific LSM hook[1].
> >
> >[1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 12 ++++++------
> >  include/linux/lsm_hooks.h              | 13 +++++++++++++
> >  include/linux/security.h               | 12 ++++++++++++
> >  security/security.c                    |  7 +++++++
> >  4 files changed, 38 insertions(+), 6 deletions(-)
> >
> >diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >index 44b2d73de7c3..29c0df672250 100644
> >--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >@@ -8,6 +8,7 @@
> >  #include <linux/highmem.h>
> >  #include <linux/ratelimit.h>
> >  #include <linux/sched/signal.h>
> >+#include <linux/security.h>
> >  #include <linux/shmem_fs.h>
> >  #include <linux/slab.h>
> >  #include <linux/suspend.h>
> >@@ -582,9 +583,6 @@ static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
> >  	struct vm_area_struct *vma;
> >  	int ret;
> >-	if (!(prot & VM_EXEC))
> >-		return 0;
> >-
> 
> Is there a real use case where LSM will want to be called if !(prot &
> VM_EXEC)?

I don't think so?  I have no objection to conditioning the LSM calls on
the page being executable.  I actually had the code written that way in
the first RFC, but it felt weird for SGX to be making assumptions about
LSM use cases.

> Also, you seem to be mixing prot and PROT_EXEC with vm_flags and
> VM_EXEC; other code does not appear to assume they are identical and
> explicitly converts, e.g. calc_vm_prot_bits().

Argh, I'll clean that up.
 
> >  	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
> >  	down_read(&current->mm->mmap_sem);
