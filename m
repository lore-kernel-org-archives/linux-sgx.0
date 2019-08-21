Return-Path: <SRS0=WfLj=WR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E518C3A59E
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 18:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFCEE2339F
	for <linux-sgx@archiver.kernel.org>; Wed, 21 Aug 2019 18:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfHUSpu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 21 Aug 2019 14:45:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:14279 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbfHUSpr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 21 Aug 2019 14:45:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 11:45:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="330109526"
Received: from kumarsh1-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.104])
  by orsmga004.jf.intel.com with ESMTP; 21 Aug 2019 11:45:45 -0700
Date:   Wed, 21 Aug 2019 21:45:44 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
Message-ID: <20190821184544.ii37h7hhxjiocbb4@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
 <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 19, 2019 at 06:25:43PM +0300, Jarkko Sakkinen wrote:
> The validation of TCS permissions was missing from
> sgx_validate_secinfo(). This patch adds the validation.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 99b1b9776c3a..2415dcb20a6e 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -423,6 +423,12 @@ static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
>  	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
>  		return -EINVAL;
>  
> +	/* CPU will silently overwrite the permissions as zero, which means
> +	 * that we need to validate it ourselves.
> +	 */
> +	if (page_type == SGX_SECINFO_TCS && perm)
> +		return -EINVAL;
> +
>  	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
>  		return -EINVAL;
>  
> -- 
> 2.20.1
> 

OK, just found out that this patch did not end up to my test image and
causes a regression.

I think this should be fixed in sgx_encl_may_map() by having the
following special case for TCS (in addition to the change in this
patch of course):

1. Check if we encounter a TCS page.
2. If yes, we evaluate RW for the VM flags.

/Jarkko
