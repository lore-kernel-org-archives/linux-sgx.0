Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC5FC35257
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 818B5207F7
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgJEDlM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 23:41:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:9923 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJEDlL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 23:41:11 -0400
IronPort-SDR: F8/lvfGrfCSp8z/OVHOwHE64O1gL8f/Qb5I9oKSqHg6Na9NFQVm0/eje4iKs1V2ueDDMeJ42ka
 21RZvHVMRZjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="150951018"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="150951018"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:41:05 -0700
IronPort-SDR: TtoJG70SrYsYtHpA4lyc3DD5AZwVmZ0ug5uNwIKtpJB6O8wLTaBy3rcOHeviY/1On6nsC8+Io1
 18GyCCDgIQMA==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="459318892"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:41:03 -0700
Date:   Mon, 5 Oct 2020 06:41:01 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v2] x86/sgx: Remove checks for platform limits from
 sgx_validate_secs()
Message-ID: <20201005034101.GA159001@linux.intel.com>
References: <20201005033803.158793-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005033803.158793-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 05, 2020 at 06:38:03AM +0300, Jarkko Sakkinen wrote:
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
> any platform, i.e. SECS limits and platform limits are orthogonal. They are
> not dependent.
> 
> Rename sgx_*_reserved_mask as sgx_cpu_* in order to bring some clarity
> and separate them from SIGSTRUCT limits.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Ugh, forgot that the masks are describing things that *are not*
allowed. Please just ignore this version. I'll take the first
version.

NAK from my side.

/Jarkko
