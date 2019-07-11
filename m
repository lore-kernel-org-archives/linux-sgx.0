Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1CBC74A5F
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC2920838
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfGKQZH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 12:25:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:36442 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbfGKQZH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 12:25:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 09:25:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="341433453"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga005.jf.intel.com with ESMTP; 11 Jul 2019 09:25:06 -0700
Date:   Thu, 11 Jul 2019 09:25:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
Message-ID: <20190711162506.GF15067@linux.intel.com>
References: <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
 <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
 <4c3e21dd-8890-e3cb-0db7-c154ac7201e1@tycho.nsa.gov>
 <20190711151245.GD7645@linux.intel.com>
 <27e55a96-d5c4-69ed-a88d-7a3c26fb7f75@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27e55a96-d5c4-69ed-a88d-7a3c26fb7f75@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 12:11:06PM -0400, Stephen Smalley wrote:
> On 7/11/19 11:12 AM, Sean Christopherson wrote:
> >On Thu, Jul 11, 2019 at 09:51:19AM -0400, Stephen Smalley wrote:
> >>I'd also feel better if there was clear consensus among all of the
> >>@intel.com participants that this is the right approach. To date that has
> >>seemed elusive.
> >
> >That's a very kind way to phrase things :-)
> >
> >For initial upstreaming, we've agreed that there is no need to extend the
> >uapi, i.e. we can punt on deciding between on-the-fly tracking and having
> >userspace specify maximal permissions until we add SGX2 support.
> >
> >The last open (knock on wood) for initial upstreaming is whether SELinux
> >would prefer to have new enclave specific permissions or reuse the
> >existing PROCESS__EXECMEM, FILE__EXECUTE and FILE__EXECMOD permissions.
> >My understanding is that enclave specific permissions are preferred.
> 
> I was left unclear on this topic after the email exchanges with Cedric.
> There are at least three options:
> 
> 1) Reuse the existing EXECMEM, EXECUTE, and EXECMOD permissions.  Pros:
> Existing distro policies will be applied in the expected manner with respect
> to the introduction of executable code into the system, consistent control
> will be provided over the enclave and the host process, no change for
> users/documentation wrt policy.  Cons: Existing permissions don't map
> exactly to SGX semantics, no ability to distinguish executable content
> within the enclave versus the host process at the LSM level (argued earlier
> by Cedric to be unnecessary and perhaps meaningless), need to allow
> FILE__EXECUTE or other checks on sigstruct files that may not actually
> contain code.
> 
> 2) Define new permissions within existing security classes (e.g. process2,
> file). Pros: Can tailor permission names and definitions to SGX semantics,
> ability to distinguish enclave versus host process execute access, no need
> to grant FILE__EXECUTE to sigstruct files, class matches the target object,
> permissions computed and cached upon existing checks (i.e. when a process
> accesses a file, all of the permissions to that file are computed and then
> cached at once, including the enclave-related ones).  Cons: Typical distro
> policies (unlike Android) allow unknown permissions by default for forward
> kernel compatibility reasons, so existing policies will permit these new
> permissions by default and enforcement will only truly take effect once
> policies are updated, adding new permissions to existing classes requires an
> update to the base policy (so they can't be shipped as a third party policy
> module alongside the SGX driver or installed as a local module by an admin,
> for example), documentation/user education required for new permissions.
> 
> 3) Define new permissions in new security classes (e.g. enclave). Pros
> relative to #2: New classes and permissions can be defined and installed in
> third party or local policy module without requiring a change to the base
> policy.  Cons relative to #2: Class won't correspond to the target object,
> permissions won't be computed and cached upon existing checks (only when
> performing the checks against the new classes).
> 
> Combinations are also possible, of course.

What's the impact on distros/ecosystems if we go with #1 for now and later
decide to switch to #2 after upstreaming?  I.e. can we take a minimal-ish
approach now without painting ourselves into a corner?

We can map quite closely to the existing intent of EXECUTE, EXECMOD and
EXECMEM via a combination of checking protections at enclave load time and
again at mmap()/mprotect(), e.g.:

#ifdef CONFIG_INTEL_SGX
static inline int enclave_has_perm(u32 sid, u32 requested)
{
	return avc_has_perm(&selinux_state, sid, sid,
			    SECCLASS_PROCESS, requested, NULL);
}

static int selinux_enclave_map(unsigned long prot)
{
	const struct cred *cred = current_cred();
	u32 sid = cred_sid(cred);

	if ((prot & PROT_EXEC) && (prot & PROT_WRITE))
		return enclave_has_perm(sid, PROCESS__EXECMEM);

	return 0;
}

static int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot)
{
	const struct cred *cred = current_cred();
	u32 sid = cred_sid(cred);
	int ret;

	/* Only executable enclave pages are restricted in any way. */
	if (!(prot & PROT_EXEC))
		return 0;

	if (!vma->vm_file || IS_PRIVATE(file_inode(vma->vm_file))) {
		ret = enclave_has_perm(sid, PROCESS__EXECMEM);
	} else {
		ret = file_has_perm(cred, vma->vm_file, FILE__EXECUTE);
		if (ret)
			goto out;

		/*
		 * Load code from a modified private mapping or from a file
		 * with the ability to do W->X within the enclave.
		 */
		if (vma->anon_vma || (prot & PROT_WRITE))
			ret = file_has_perm(cred, vma->vm_file,
					    FILE__EXECMOD);
	}

out:
	return ret;
}
#endif
