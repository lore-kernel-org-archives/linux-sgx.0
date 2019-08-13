Return-Path: <SRS0=R+G5=WJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02F8C31E40
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FF3820665
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfHMBW2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:22:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:15056 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbfHMBW2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Aug 2019 21:22:28 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 18:22:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="375438220"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 12 Aug 2019 18:22:27 -0700
Date:   Mon, 12 Aug 2019 18:22:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Message-ID: <20190813012227.GJ4996@linux.intel.com>
References: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
 <20190715135902.GA442@linux.intel.com>
 <20190801162219.fqmkxlp4mgm4gi3f@linux.intel.com>
 <20190801162931.GB6783@linux.intel.com>
 <20190802193321.llx4dcqhslh46toy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802193321.llx4dcqhslh46toy@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 02, 2019 at 10:33:38PM +0300, Jarkko Sakkinen wrote:
> On Thu, Aug 01, 2019 at 09:29:31AM -0700, Sean Christopherson wrote:
> > On Thu, Aug 01, 2019 at 07:22:19PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Jul 15, 2019 at 06:59:03AM -0700, Sean Christopherson wrote:
> > > > On Sun, Jul 14, 2019 at 05:32:12PM +0300, Jarkko Sakkinen wrote:
> > > > > When the config option is not enabled the initialization is always
> > > > > succesful.
> > > > 
> > > > Why would the be initialization be considered successful?  It's dead code
> > > > and memory consumption if the driver can't load.  When KVM support gets
> > > > added, the initialization can be considered successful if the driver *or*
> > > > virtual EPC are enabled and load cleanly.
> > > 
> > > When a config option disabled means it that the functionality does not
> > > exist at all, which means that there is nothing to fail. That is why it
> > > would be actually better to flag the whole call than the way it is done
> > > in this patch.
> > 
> > Regardless of how it's done, the core SGX management shouldn't consume
> > resources if it doesn't have downstream consumers.  Making INTEL_SGX
> > depend on INTEL_SGX_DRIVER is the obvious alternative.
> 
> Is there a specific blocker that prevents using SGX just with KVM when
> the latter option is disabled?

Nope, KVM does not have any dependencies on the native driver.  But if
sgx_drv_init() returns 0 when CONFIG_INTEL_SGX_DRIVER=n, then sgx_init()
won't handle KVM failure correctly since it will think the native driver
initialized cleanly.  E.g. with both KVM and driver in play, I was
thinking of something like this in sgx_init():

        /* Success if the native *or* virtual driver initialized cleanly. */
        ret = sgx_drv_init();
        ret = sgx_virt_epc_init() ? ret : 0;
        if (ret)
		goto err;

	return 0;

If sgx_drv_init() returns 0 when CONFIG_INTEL_SGX_DRIVER=n, then failure
in sgx_virt_epc_init() is ignored and we end up with the SGX subsystem
wasting resources again.
