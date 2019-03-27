Return-Path: <SRS0=L3CU=R6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D038CC43381
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 17:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A844E2082F
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Mar 2019 17:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfC0R5E (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 27 Mar 2019 13:57:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:25168 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfC0R5E (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 27 Mar 2019 13:57:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Mar 2019 10:57:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,277,1549958400"; 
   d="scan'208";a="137910730"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga007.fm.intel.com with ESMTP; 27 Mar 2019 10:57:03 -0700
Date:   Wed, 27 Mar 2019 10:57:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190327175703.GD9310@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
 <20190326235852.GL3757@linux.intel.com>
 <20190327052830.GF15397@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327052830.GF15397@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

+Cc Jethro, AFAIK he is the only person who expressed a desire to have a
loadable module.

On Wed, Mar 27, 2019 at 07:28:30AM +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 26, 2019 at 04:58:52PM -0700, Sean Christopherson wrote:
> > On Tue, Mar 26, 2019 at 03:26:50PM +0200, Jarkko Sakkinen wrote:
> > > On Thu, Mar 21, 2019 at 05:51:11PM +0200, Jarkko Sakkinen wrote:
> > > > > Yuck.  If we remove the driver specific Makefile then we can eliminate
> > > > > the "../" prefix here.  E.g. in the main SGX Makefile:
> > > > > 
> > > > > obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/main.o driver/ioctl.o
> > > > 
> > > > I think this is a great idea.
> > > 
> > > On a 2nd thought not gonna do anything to that because it would
> > > require to move driver.h and it is cleaner to keep all the driver
> > > files in the same directory (and separated from the core).
> > 
> > What about collapsing driver/*.c into driver.c and moving driver.{c,h}
> > to the root sgx directory?  The bulk of driver/main.c is securityfs
> > and platform driver code, e.g. has a good chance of going away entirely
> > or being moved out of the "driver".  At that point there probably isn't
> > a strong reason to have driver/main.c and driver/ioctl.c.
> 
> I think doing anything major would require to lock in whether to have
> the LKM for the driver at all. If we wipe out the driver, then this is
> just matter of moving dev management part to lets say dev.c.
> 
> Unless there is some real production use I can wipe it away. For v19
> I wanted to fix it namely because in v18 LKM was just broken. It is
> always good to make decisions based on working code.
> 
> /Jarkko
