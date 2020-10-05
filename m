Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E487C4363A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 04:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B10F52063A
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 04:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgJEEAg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Oct 2020 00:00:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:23961 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgJEEAg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Oct 2020 00:00:36 -0400
IronPort-SDR: o3gU+UZN3reU1F7Kkj3G3Bt9DqLLEoOLUxKvtgFG7yEXt87QL8CNGSu11f2bYZ/z8qJcml8/r9
 1RRHTvSmVzxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="151109237"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="151109237"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 21:00:32 -0700
IronPort-SDR: 1CIw0HeOFWQ3g13kDFeF0aX/G/lGe0Km8c1qlo7EJB5HFpejx3IYLzRqDWNoZGYO6V5dgCLRHL
 1wRLCAHh8vbw==
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="459322183"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO mqcpg7oapc828.gar.corp.intel.com) ([10.255.36.21])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 04 Oct 2020 21:00:30 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] x86/sgx: Remove checks for platform limits from
 sgx_validate_secs()
References: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
Date:   Sun, 04 Oct 2020 23:00:28 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0rzxe2jtwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
In-Reply-To: <20201005020819.124724-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, 04 Oct 2020 21:08:19 -0500, Jarkko Sakkinen  
<jarkko.sakkinen@linux.intel.com> wrote:

> Remove from sgx_validate_secs():
>
> 	if (secs->miscselect & sgx_misc_reserved_mask ||
> 	    secs->attributes & sgx_attributes_reserved_mask ||
> 	    secs->xfrm & sgx_xfrm_reserved_mask)
> 		return -EINVAL;
>
> SECS can surpass the platform limits because it's the SIGSTRUCT that
> defines the limits that are used at run-time.
>
> What SECS does is that it defines the overall limits that must apply for
> any platform, i.e.  SECS limits and platform limits are orthogonal. They
> are not dependent.
>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c  
> b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 6b3cc8483008..008752cb54f0 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -86,11 +86,6 @@ static int sgx_validate_secs(const struct sgx_secs  
> *secs)
>  	if (secs->base & (secs->size - 1))
>  		return -EINVAL;
> -	if (secs->miscselect & sgx_misc_reserved_mask ||
> -	    secs->attributes & sgx_attributes_reserved_mask ||
> -	    secs->xfrm & sgx_xfrm_reserved_mask)
> -		return -EINVAL;
> -
>  	if (secs->size > max_size)
>  		return -EINVAL;
>

Looks good to me.
Thanks
Haitao
