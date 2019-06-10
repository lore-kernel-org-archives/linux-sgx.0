Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C704BC31E40
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97E7720820
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfFJQqw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:46:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:45688 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbfFJQqw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 12:46:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 09:46:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,575,1557212400"; 
   d="scan'208";a="183489250"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jun 2019 09:46:50 -0700
Date:   Mon, 10 Jun 2019 09:46:50 -0700
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
Subject: Re: [RFC PATCH v2 5/5] security/selinux: Add enclave_load()
 implementation
Message-ID: <20190610164650.GE15995@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-6-sean.j.christopherson@intel.com>
 <ca77e597-69de-9db4-f88a-26881ab53680@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca77e597-69de-9db4-f88a-26881ab53680@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 07, 2019 at 05:16:01PM -0400, Stephen Smalley wrote:
> On 6/5/19 10:11 PM, Sean Christopherson wrote:
> >The goal of selinux_enclave_load() is to provide a facsimile of the
> >existing selinux_file_mprotect() and file_map_prot_check() policies,
> >but tailored to the unique properties of SGX.
> >
> >For example, an enclave page is technically backed by a MAP_SHARED file,
> >but the "file" is essentially shared memory that is never persisted
> >anywhere and also requires execute permissions (for some pages).
> >
> >The basic concept is to require appropriate execute permissions on the
> >source of the enclave for pages that are requesting PROT_EXEC, e.g. if
> >an enclave page is being loaded from a regular file, require
> >FILE__EXECUTE and/or FILE__EXECMOND, and if it's coming from an
> >anonymous/private mapping, require PROCESS__EXECMEM since the process
> >is essentially executing from the mapping, albeit in a roundabout way.
> >
> >Note, FILE__READ and FILE__WRITE are intentionally not required even if
> >the source page is backed by a regular file.  Writes to the enclave page
> >are contained to the EPC, i.e. never hit the original file, and read
> >permissions have already been vetted (or the VMA doesn't have PROT_READ,
> >in which case loading the page into the enclave will fail).
> >
> >Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >---
> >  security/selinux/hooks.c | 69 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 69 insertions(+)
> >
> >diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >index 3ec702cf46ca..3c5418edf51c 100644
> >--- a/security/selinux/hooks.c
> >+++ b/security/selinux/hooks.c
> >@@ -6726,6 +6726,71 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
> >  }
> >  #endif
> >+#ifdef CONFIG_INTEL_SGX
> >+int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot)
> >+{
> >+	const struct cred *cred = current_cred();
> >+	u32 sid = cred_sid(cred);
> >+	int ret;
> >+
> >+	/* SGX is supported only in 64-bit kernels. */
> >+	WARN_ON_ONCE(!default_noexec);
> >+
> >+	/* Only executable enclave pages are restricted in any way. */
> >+	if (!(prot & PROT_EXEC))
> >+		return 0;
> 
> prot/PROT_EXEC or vmflags/VM_EXEC
> 
> >+
> >+	/*
> >+	 * The source page is exectuable, i.e. has already passed SELinux's
> 
> executable
> 
> >+	 * checks, and userspace is not requesting RW->RX capabilities.
> 
> Is it requesting W->X or WX?

Hmm, good point.  I'll reword the "requesting RW->RX" and "RW->RX intent"
phrases to make it clear that we don't actually know whether userspace
intends to do W->X or WX, and I'll also expand the "Note, this hybrid
EXECMOD and EXECMEM behavior" comment to explain that existing checks
won't prevent WX.

> >+	 */
> >+	if ((vma->vm_flags & VM_EXEC) && !(prot & PROT_WRITE))
> >+		return 0;
> >+
> >+	/*
> >+	 * The source page is not executable, or userspace is requesting the
> >+	 * ability to do a RW->RX conversion.  Permissions are required as
> >+	 * follows, in order of increasing privelege:
> >+	 *
> >+	 * EXECUTE - Load an executable enclave page without RW->RX intent from
> >+	 *           a non-executable vma that is backed by a shared mapping to
> >+	 *           a regular file that has not undergone COW.
> 
> Shared mapping or unmodified private file mapping

Doh, messed that up.  Thanks!

> >+	 *
> >+	 * EXECMOD - Load an executable enclave page without RW->RX intent from
> >+	 *           a non-executable vma that is backed by a shared mapping to
> >+	 *           a regular file that *has* undergone COW.
> 
> modified private file mapping (write to shared mapping won't trigger COW; it
> would have been checked by FILE__WRITE earlier)

Same mental error.  Will fix.

> >+	 *
> >+	 *         - Load an enclave page *with* RW->RX intent from a shared
> >+	 *           mapping to a regular file.
> >+	 *
> >+	 * EXECMEM - Load an exectuable enclave page from an anonymous mapping.
> 
> executable
> 
> >+	 *
> >+	 *         - Load an exectuable enclave page from a private file, e.g.
> 
> executable

At least I'm consistent.

> >+	 *           from a shared mapping to a hugetlbfs file.
> >+	 *
> >+	 *         - Load an enclave page *with* RW->RX intent from a private
> 
> W->X or WX?
>
> >+	 *           mapping to a regular file.
> >+	 *
> >+	 * Note, this hybrid EXECMOD and EXECMEM behavior is intentional and
> >+	 * reflects the nature of enclaves and the EPC, e.g. EPC is effectively
> >+	 * a non-persistent shared file, but each enclave is a private domain
> >+	 * within that shared file, so delegate to the source of the enclave.
> >+	 */
> >+	if (vma->vm_file && !IS_PRIVATE(file_inode(vma->vm_file) &&
> >+	    ((vma->vm_flags & VM_SHARED) || !(prot & PROT_WRITE)))) {
> >+		if (!vma->anon_vma && !(prot & PROT_WRITE))
> >+			ret = file_has_perm(cred, vma->vm_file, FILE__EXECUTE);
> >+		else
> >+			ret = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
> >+	} else {
> >+		ret = avc_has_perm(&selinux_state,
> >+				   sid, sid, SECCLASS_PROCESS,
> >+				   PROCESS__EXECMEM, NULL);
> >+	}
> >+	return ret;
> >+}
> >+#endif
> >+
> >  struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
> >  	.lbs_cred = sizeof(struct task_security_struct),
> >  	.lbs_file = sizeof(struct file_security_struct),
> >@@ -6968,6 +7033,10 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
> >  	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
> >  	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
> >  #endif
> >+
> >+#ifdef CONFIG_INTEL_SGX
> >+	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
> >+#endif
> >  };
> >  static __init int selinux_init(void)
> >
> 
