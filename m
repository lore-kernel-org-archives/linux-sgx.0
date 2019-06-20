Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C435EC43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 21:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937E72070B
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 21:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfFTVJS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 17:09:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:29919 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfFTVJS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 17:09:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 14:09:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="311795343"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by orsmga004.jf.intel.com with ESMTP; 20 Jun 2019 14:09:10 -0700
Date:   Fri, 21 Jun 2019 00:09:08 +0300
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
Subject: Re: [RFC PATCH v4 02/12] x86/sgx: Do not naturally align MAP_FIXED
 address
Message-ID: <20190620210851.GG15383@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:51PM -0700, Sean Christopherson wrote:
> SGX enclaves have an associated Enclave Linear Range (ELRANGE) that is
> tracked and enforced by the CPU using a base+mask approach, similar to
> how hardware range registers such as the variable MTRRs.  As a result,
> the ELRANGE must be naturally sized and aligned.
> 
> To reduce boilerplate code that would be needed in every userspace
> enclave loader, the SGX driver naturally aligns the mmap() address and
> also requires the range to be naturally sized.  Unfortunately, SGX fails
> to grant a waiver to the MAP_FIXED case, e.g. incorrectly rejects mmap()
> if userspace is attempting to map a small slice of an existing enclave.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index 07aa5f91b2dd..29384cdd0842 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -115,7 +115,13 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
>  					   unsigned long pgoff,
>  					   unsigned long flags)
>  {
> -	if (len < 2 * PAGE_SIZE || len & (len - 1) || flags & MAP_PRIVATE)
> +	if (flags & MAP_PRIVATE)
> +		return -EINVAL;
> +
> +	if (flags & MAP_FIXED)
> +		return addr;
> +
> +	if (len < 2 * PAGE_SIZE || len & (len - 1))
>  		return -EINVAL;

Why the last check is needed given that mmap() no longer does not
associate with the layout of the enclave? I'd just wipe it away.

/Jarkko
