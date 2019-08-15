Return-Path: <SRS0=qhvV=WL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320A0C3A589
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Aug 2019 21:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41562083B
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Aug 2019 21:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfHOV4E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 15 Aug 2019 17:56:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:38011 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbfHOV4E (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 15 Aug 2019 17:56:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 14:56:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="167870133"
Received: from schuberw-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.145])
  by orsmga007.jf.intel.com with ESMTP; 15 Aug 2019 14:56:02 -0700
Date:   Fri, 16 Aug 2019 00:56:00 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Message-ID: <20190815215600.u3cz27y27nrldq3i@linux.intel.com>
References: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
 <20190715135902.GA442@linux.intel.com>
 <20190801162219.fqmkxlp4mgm4gi3f@linux.intel.com>
 <20190801162931.GB6783@linux.intel.com>
 <20190802193321.llx4dcqhslh46toy@linux.intel.com>
 <20190813012227.GJ4996@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813012227.GJ4996@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 12, 2019 at 06:22:27PM -0700, Sean Christopherson wrote:
> Nope, KVM does not have any dependencies on the native driver.  But if
> sgx_drv_init() returns 0 when CONFIG_INTEL_SGX_DRIVER=n, then sgx_init()
> won't handle KVM failure correctly since it will think the native driver
> initialized cleanly.  E.g. with both KVM and driver in play, I was
> thinking of something like this in sgx_init():
> 
>         /* Success if the native *or* virtual driver initialized cleanly. */
>         ret = sgx_drv_init();
>         ret = sgx_virt_epc_init() ? ret : 0;
>         if (ret)
> 		goto err;
> 
> 	return 0;
> 
> If sgx_drv_init() returns 0 when CONFIG_INTEL_SGX_DRIVER=n, then failure
> in sgx_virt_epc_init() is ignored and we end up with the SGX subsystem
> wasting resources again.

I get what you are saying but what exist now does not align with this
and on the other hand nothing prevents the reconsider the flow once we
get to this point.

/Jarkko
