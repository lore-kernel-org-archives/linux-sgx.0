Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E151C74A2B
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 16:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A38E20665
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 16:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfGJQ57 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 12:57:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:22559 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727414AbfGJQ57 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 12:57:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 09:57:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="156555167"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga007.jf.intel.com with ESMTP; 10 Jul 2019 09:57:58 -0700
Date:   Wed, 10 Jul 2019 09:57:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
Message-ID: <20190710165758.GD4348@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <512391ba-fe0d-e758-ae32-09660c1264f7@intel.com>
 <20190709222534.GG25369@linux.intel.com>
 <35b9dd93-4988-d998-056c-aeae36076bc0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35b9dd93-4988-d998-056c-aeae36076bc0@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 09, 2019 at 04:11:08PM -0700, Xing, Cedric wrote:
> On 7/9/2019 3:25 PM, Sean Christopherson wrote:
> >On Tue, Jul 09, 2019 at 01:41:28PM -0700, Xing, Cedric wrote:
> >>On 7/9/2019 10:09 AM, Sean Christopherson wrote:
> >>>Translating those to SGX, with a lot of input from Stephen, I ended up
> >>>with the following:
> >>>
> >>>   - FILE__ENCLAVE_EXECUTE: equivalent to FILE__EXECUTE, required to gain X
> >>>                            on an enclave page loaded from a regular file
> >>>
> >>>   - PROCESS2__ENCLAVE_EXECDIRTY: hybrid of EXECMOD and EXECUTE+WRITE,
> >>>                                  required to gain W->X on an enclave page
> >>
> >>EXECMOD basically indicates a file containing self-modifying code. Your
> >>ENCLAVE_EXECDIRTY is however a process permission, which is illogical.
> >
> >How is it illogical?  If a PROCESS wants to EXECute a DIRTY ENCLAVE page,
> >then it needs PROCESS2__ENCLAVE_EXECDIRTY
> Just think of the purpose of FILE__EXECMOD. It indicates to LSM the file has
> self-modifying code, hence W->X transition should be considered "normal" and
> allowed, regardless which process that file is loaded into.
> 
> The same thing for enclaves here. Whether an enclave contains self-modifying
> code is specific to that enclave, regardless which process it is loaded
> into.
> 
> But what are you doing is quite the opposite, and that's I mean by
> "illogical".

Ah.  My intent was to minimize the number of new labels, and because W->X
scenarios are not guaranteed to be backed by a file, I went with a per
process permission.  Ditto for EXECANON.  I'm not opposed to also having a
per file permission that can be used when possible.

Something like this?  And maybe merge EXECANON and EXECDIRTY into a single
permission?

Depending on whether sigstruct is required to be in a pinned file, EAUG
pages would need either EXECDIRTY or EXECMOD.

static int selinux_enclave_load(struct vm_area_struct *vma, unsigned long prot,
				bool measured)
{
	const struct cred *cred = current_cred();
	u32 sid = cred_sid(cred);
	int ret;

	/* Currently supported only in noexec kernels. */
	WARN_ON_ONCE(!default_noexec);

	/* Only executable enclave pages are restricted in any way. */
	if (!(prot & PROT_EXEC))
		return 0;

	if (!measured) {
		ret = enclave_has_perm(sid, PROCESS2__ENCLAVE_EXECUNMR);
		if (ret)
			goto out;
	}

	if (!vma->vm_file || IS_PRIVATE(file_inode(vma->vm_file))) {
		ret = enclave_has_perm(sid, PROCESS2__ENCLAVE_EXECANON);
		if (ret)
			goto out;

		/* Ability to do W->X within the enclave. */
		if (prot & PROT_WRITE)
			ret = enclave_has_perm(sid,
					       PROCESS2__ENCLAVE_EXECDIRTY);
	} else {
		ret = file_has_perm(cred, vma->vm_file, FILE__ENCLAVE_EXECUTE);
		if (ret)
			goto out;

		/*
		 * Load code from a modified private mapping, or from any file
		 * mapping with the ability to do W->X within the enclave.
		 */
		if (vma->anon_vma || (prot & PROT_WRITE))
			ret = file_has_perm(cred, vma->vm_file,
					    FILE__ENCLAVE_EXECMOD);
	}

out:
	return ret;
}
