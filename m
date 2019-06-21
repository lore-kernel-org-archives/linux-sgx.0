Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4CCC43613
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 01:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0682084A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 01:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfFUBIB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 21:08:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:22286 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUBIB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 21:08:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 18:08:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="359138123"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2019 18:07:54 -0700
Date:   Fri, 21 Jun 2019 04:07:53 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190621010753.GG20474@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:53PM -0700, Sean Christopherson wrote:
>  arch/x86/include/uapi/asm/sgx.h        |  6 ++--
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 15 +++++---
>  arch/x86/kernel/cpu/sgx/driver/main.c  | 49 ++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h         |  1 +
>  tools/testing/selftests/x86/sgx/main.c | 32 +++++++++++++++--

Please split the kselftest change to a separate patch.

>  5 files changed, 94 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 6dba9f282232..67a3babbb24d 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -35,15 +35,17 @@ struct sgx_enclave_create  {
>   * @src:	address for the page data
>   * @secinfo:	address for the SECINFO data
>   * @mrmask:	bitmask for the measured 256 byte chunks
> + * @prot:	maximal PROT_{READ,WRITE,EXEC} protections for the page
>   */
>  struct sgx_enclave_add_page {
>  	__u64	addr;
>  	__u64	src;
>  	__u64	secinfo;
> -	__u64	mrmask;
> +	__u16	mrmask;
> +	__u8	prot;
> +	__u8	pad;

__u8 pad[7];

> +/*
> + * Returns the AND of VM_{READ,WRITE,EXEC} permissions across all pages
> + * covered by the specific VMA.  A non-existent (or yet to be added) enclave
> + * page is considered to have no RWX permissions, i.e. is inaccessible.
> + */

That was a bit hard to grasp (at least for me). I would rephrase it like:

/**
 * sgx_calc_vma_prot_intersection() - Calculate intersection of the permissions
 *				      for a VMA
 * @encl:	an enclave
 * @vma:	a VMA inside the enclave
 *
 * Iterate through the page addresses inside the VMA and calculate a bitmask
 * of permissions that all pages have in common. Page addresses that do
 * not have an associated enclave page are interpreted to zero
 * permissions.
 */

> +static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
> +				     struct vm_area_struct *vma)

Suggestion for the name: sgx_calc_vma_prot_intersection()

> +{
> +	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
> +	unsigned long idx, idx_start, idx_end;
> +	struct sgx_encl_page *page;
> +
> +	idx_start = PFN_DOWN(vma->vm_start);
> +	idx_end = PFN_DOWN(vma->vm_end - 1);

Suggestion: just open code these to the for-statement.

> +
> +	for (idx = idx_start; idx <= idx_end; ++idx) {
> +		/*
> +		 * No need to take encl->lock, vm_prot_bits is set prior to
> +		 * insertion and never changes, and racing with adding pages is
> +		 * a userspace bug.
> +		 */
> +		rcu_read_lock();
> +		page = radix_tree_lookup(&encl->page_tree, idx);
> +		rcu_read_unlock();
> +
> +		/* Do not allow R|W|X to a non-existent page. */
> +		if (!page)
> +			allowed_rwx = 0;
> +		else
> +			allowed_rwx &= page->vm_prot_bits;

This would be a more clean way to express the same:

	if (!page)
		return 0;

	allowed_rwx &= page->vm_prot_bits;

/Jarkko
