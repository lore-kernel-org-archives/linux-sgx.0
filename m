Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE10EC43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 23:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91BAC2087C
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 23:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbfCZX6y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 19:58:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:22251 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfCZX6y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 19:58:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Mar 2019 16:58:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,274,1549958400"; 
   d="scan'208";a="144156281"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Mar 2019 16:58:52 -0700
Date:   Tue, 26 Mar 2019 16:58:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190326235852.GL3757@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190326132650.GA31662@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326132650.GA31662@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 26, 2019 at 03:26:50PM +0200, Jarkko Sakkinen wrote:
> On Thu, Mar 21, 2019 at 05:51:11PM +0200, Jarkko Sakkinen wrote:
> > > Yuck.  If we remove the driver specific Makefile then we can eliminate
> > > the "../" prefix here.  E.g. in the main SGX Makefile:
> > > 
> > > obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/main.o driver/ioctl.o
> > 
> > I think this is a great idea.
> 
> On a 2nd thought not gonna do anything to that because it would
> require to move driver.h and it is cleaner to keep all the driver
> files in the same directory (and separated from the core).

What about collapsing driver/*.c into driver.c and moving driver.{c,h}
to the root sgx directory?  The bulk of driver/main.c is securityfs
and platform driver code, e.g. has a good chance of going away entirely
or being moved out of the "driver".  At that point there probably isn't
a strong reason to have driver/main.c and driver/ioctl.c.
