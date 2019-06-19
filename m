Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A100EC43613
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 20:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7357421537
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 20:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFSU7i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 16:59:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:34651 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfFSU7h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 16:59:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 13:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,394,1557212400"; 
   d="scan'208";a="162151515"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jun 2019 13:59:36 -0700
Date:   Wed, 19 Jun 2019 13:59:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v3 10/12] security/selinux: Add enclave_load()
 implementation
Message-ID: <20190619205936.GI1203@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-11-sean.j.christopherson@intel.com>
 <267cb58d-aea2-b33c-e711-84cb5fb0ad8e@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267cb58d-aea2-b33c-e711-84cb5fb0ad8e@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 18, 2019 at 10:49:55AM -0400, Stephen Smalley wrote:
> On 6/17/19 6:24 PM, Sean Christopherson wrote:
> >diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> >index 22e0f4a71333..ea452a416fe1 100644
> >--- a/security/selinux/hooks.c
> >+++ b/security/selinux/hooks.c
> >@@ -6727,6 +6727,12 @@ static void selinux_bpf_prog_free(struct bpf_prog_aux *aux)
> >  #endif
> >  #ifdef CONFIG_INTEL_SGX
> >+static inline int sgx_has_perm(u32 sid, u32 requested)
> >+{
> >+	return avc_has_perm(&selinux_state, sid, sid,
> >+			    SECCLASS_PROCESS2, requested, NULL);
> >+}
> >+
> >  static int selinux_enclave_map(unsigned long prot)
> >  {
> >  	const struct cred *cred = current_cred();
> >@@ -6736,11 +6742,53 @@ static int selinux_enclave_map(unsigned long prot)
> >  	WARN_ON_ONCE(!default_noexec);
> >  	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
> >-		return avc_has_perm(&selinux_state, sid, sid,
> >-				    SECCLASS_PROCESS2, PROCESS2__SGX_EXECMEM,
> >-				    NULL);
> >+		return sgx_has_perm(sid, PROCESS2__SGX_EXECMEM);
> >+
> >  	return 0;
> >  }
> >+
> >+static int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> >+				bool measured)
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
> >+
> >+	/*
> >+	 * WX at load time only requires EXECMOD, e.g. to allow W->X.  Actual
> >+	 * WX mappings require EXECMEM (see selinux_enclave_map()).
> >+	 */
> >+	if (prot & PROT_WRITE) {
> >+		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECMOD);
> 
> So, security_enclave_load() can be called with PROT_WRITE|PROT_EXEC, but the
> subsequent calls to security_enclave_map() won't have both set unless a
> mapping is actually simultaneously WX?  Is that correct? Trying to make sure
> that every PROCESS2__SGX_EXECMOD check here won't be followed immediately by
> a PROCESS2__SGX_EXECMEM check from security_enclave_map(), thereby rendering
> any distinction between them moot.

Yes, @prot passed to security_enclave_map() will be the actual protection
bits being set by mmap() or mprotect().

Note, I intentionally omitted @reqprot from .enclave_map() as SGX doesn't
have that information when it calls security_enclave_map() in its mmap()
hook.  Given that checking @reqprot reduces security, I assumed this is a
non-issue.

> >+		if (ret)
> >+			goto out;
> >+	}
> >+	if (!measured) {
> >+		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECUNMR);
> 
> I'm unclear on the concept of loading unmeasured code into an enclave; I
> thought that wasn't supposed to happen apart from SGX2.  How does that
> occur?

Adding a page, i.e. EADD, updates enclave's measurement with the offset and
protection bits of the page, but not the page contents.  The contents of
the page are included in the enclave measurement by executing EEXTEND.
Whether or not a page (technically 256 byte chunks) is measured is purely
controlled by userspace (via the @mrmask param in the add page ioctl()).

Put differently, SGX ISA does not require code pages to be measured, nor
does the SGX driver.  The SGX driver also does *not* zero out unmeasured
pages.  This means an enclave can load unmeasured RX or X pages.

The expected use case is Graphene and the like, which is essentially a two
step load.  The measured enclave code is a shim that wraps an unmodified
non-SGX application, e.g. redis.  Before running the unmeasured code, the
measured portion of the enclave verifies the unmeasured code.

> >+		if (ret)
> >+			goto out;
> >+	}
> >+
> >+	if (!vma->vm_file || !IS_PRIVATE(file_inode(vma->vm_file)) ||
> 
> I think this should be IS_PRIVATE(), not !IS_PRIVATE()?

Argh, thanks!

> >+	    vma->anon_vma)
> >+		/*
> >+		 * Loading enclave code from an anonymous mapping or from a
> >+		 * modified private file mapping.
> >+		 */
> >+		ret = sgx_has_perm(sid, PROCESS2__SGX_EXECANON);
> 
> I might have expected this to be EXECMEM.  It is actually a blend of EXECMEM
> and EXECMOD, so I'm ok with the new name.

Ya, my thought was that we'd want to distinguish between building an
enclave in memory (EXECANON) and the enclave itself modifying its code
(EXECMOD).

> However, I'm wondering if you
> should use an entirely different set of permission names than EXECMEM or
> EXECMOD for the other checks too since none of them quite align with the
> existing usage; your SGX__EXECMEM is effectively MAPWX and your SGX__EXECMOD
> is effectively MAPXAFTERW.  Or something like that.

Hmm, I was thinking that reusing the names would aid in understanding the
SGX specific concepts, but it's definitely a double edge sword.

How about SGX__MAPWX (was EXECMEM) and SGX__EXECDIRTY (was EXECMOD)?

MAPXAFTERW isn't technically accurate for the SGX1 case of loading a WX
page, e.g. the permission is required even if the page is never mapped.

> >+	else
> >+		/* Loading from a shared or unmodified private file mapping. */
> >+		ret = file_has_perm(cred, vma->vm_file, FILE__SGX_EXECUTE);
> >+out:
> >+	return ret;
> >+}
> >  #endif
> >  struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
> >@@ -6988,6 +7036,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
> >  #ifdef CONFIG_INTEL_SGX
> >  	LSM_HOOK_INIT(enclave_map, selinux_enclave_map),
> >+	LSM_HOOK_INIT(enclave_load, selinux_enclave_load),
> >  #endif
> >  };
> >diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> >index 0f525f5b926f..29a0a74268cd 100644
> >--- a/security/selinux/include/classmap.h
> >+++ b/security/selinux/include/classmap.h
> >@@ -52,7 +52,8 @@ struct security_class_mapping secclass_map[] = {
> >  	    "setsockcreate", "getrlimit", NULL } },
> >  	{ "process2",
> >  	  { "nnp_transition", "nosuid_transition",
> >-	    "sgx_execmem", NULL } },
> >+	    "sgx_execmem", "sgx_execmod", "sgx_execanon", "sgx_execunmr",
> >+	    NULL } },
> >  	{ "system",
> >  	  { "ipc_info", "syslog_read", "syslog_mod",
> >  	    "syslog_console", "module_request", "module_load", NULL } },
> >@@ -64,7 +65,7 @@ struct security_class_mapping secclass_map[] = {
> >  	    "quotaget", NULL } },
> >  	{ "file",
> >  	  { COMMON_FILE_PERMS,
> >-	    "execute_no_trans", "entrypoint", NULL } },
> >+	    "execute_no_trans", "entrypoint", "sgx_execute", NULL } },
> 
> If there is any possibility of a mapping of a non-regular file reaching the
> point of the permission check, then the permission needs to either be added
> to COMMON_FILE_PERMS or be added to each of the *_file classes for which it
> can legitimately be checked.  That's why execmod is in COMMON_FILE_PERMS; it
> can show up on e.g. a modified private file mapping of a device file in
> addition to regular files.

Ah, yes.  Adding it to COMMON_FILE_PERMS seems like the safest bet.

> >  	{ "dir",
> >  	  { COMMON_FILE_PERMS, "add_name", "remove_name",
> >  	    "reparent", "search", "rmdir", NULL } },
> >
> 
