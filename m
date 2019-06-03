Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E559C28D17
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 14:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A04260F7
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 14:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfFCOmy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 10:42:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:43612 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbfFCOmx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 07:42:52 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 03 Jun 2019 07:42:51 -0700
Date:   Mon, 3 Jun 2019 07:42:51 -0700
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
Subject: Re: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Message-ID: <20190603144251.GB13384@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-9-sean.j.christopherson@intel.com>
 <d9ef6314-de91-ddcb-3d18-8155cd37e7be@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9ef6314-de91-ddcb-3d18-8155cd37e7be@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 03, 2019 at 10:19:18AM -0400, Stephen Smalley wrote:
> On 5/31/19 7:31 PM, Sean Christopherson wrote:
> >enclave_load() is roughly analogous to the existing file_mprotect().
> >
> >Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> >VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> >MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> >VMAs.  As a result, file_mprotect() does not provide any meaningful
> >security for enclaves since an LSM can only deny/grant access to the
> >EPC as a whole.
> >
> >security_enclave_load() is called when SGX is first loading an enclave
> >page, i.e. copying a page from normal memory into the EPC.  The notable
> >difference from file_mprotect() is the allowed_prot parameter, which
> >is essentially an SGX-specific version of a VMA's MAY_{READ,WRITE,EXEC}
> >flags.  The purpose of allowed_prot is to enable checks such as
> >SELinux's FILE__EXECMOD permission without having to track and update
> >VMAs across multiple mm structs, i.e. SGX can ensure userspace doesn't
> >overstep its bounds simply by restricting an enclave VMA's protections
> >by vetting what is maximally allowed during build time.
> >
> >An alternative to the allowed_prot approach would be to use an enclave's
> >SIGSTRUCT (a smallish structure that can uniquely identify an enclave)
> >as a proxy for the enclave.  For example, SGX could take and hold a
> >reference to the file containing the SIGSTRUCT (if it's in a file) and
> >call security_enclave_load() during mprotect().  While the SIGSTRUCT
> >approach would provide better precision, the actual value added was
> >deemed to be negligible.  On the other hand, pinning a file for the
> >lifetime of the enclave is ugly, and essentially caching LSM policies
> >in each page's allowed_prot avoids having to make an extra LSM upcall
> >during mprotect().
> >
> >Note, extensive discussion yielded no sane alternative to some form of
> >SGX specific LSM hook[1].
> >
> >[1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 +++++++++-----
> >  include/linux/lsm_hooks.h              | 16 ++++++++++++++++
> >  include/linux/security.h               |  2 ++
> >  security/security.c                    |  8 ++++++++
> >  4 files changed, 35 insertions(+), 5 deletions(-)
> >
> >diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >index 5f71be7cbb01..260417ecbcff 100644
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
> >@@ -580,21 +581,24 @@ static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
> >  				 unsigned long *allowed_prot)
> >  {
> >  	struct vm_area_struct *vma;
> >+	int ret = 0;
> >-	if (!(*allowed_prot & VM_EXEC))
> >+	if (!(*allowed_prot & VM_EXEC) && !IS_ENABLED(CONFIG_SECURITY))
> >  		goto do_check;
> >  	down_read(&current->mm->mmap_sem);
> >  	vma = find_vma(current->mm, src);
> >  	if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
> >  		*allowed_prot &= ~VM_EXEC;
> >+#ifdef CONFIG_SECURITY
> >+	ret = security_enclave_load(vma, prot, allowed_prot);
> >+#endif
> 
> Normally you'd define a static inline stub for the hook in the #else clause
> for CONFIG_SECURITY in include/linux/security.h and avoid any ifdef here.

Ah, right.
 
> What ensures that the mapping referenced by src can't be changed to an
> entirely different one (with a different vm_file) between the time of check
> (here) and the time of use?

Nothing.  Holding mmap_sem across copy_from_user() would suffice, correct?

> >  	up_read(&current->mm->mmap_sem);
> >  do_check:
> >-	if (prot & ~*allowed_prot)
> >-		return -EACCES;
> >-
> >-	return 0;
> >+	if (!ret && (prot & ~*allowed_prot))
> >+		ret = -EACCES;
> >+	return ret;
> >  }
> >  static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
