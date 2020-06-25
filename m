Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20216C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 01:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0086920789
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 01:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388962AbgFYB2y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:28:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:51192 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388928AbgFYB2y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Jun 2020 21:28:54 -0400
IronPort-SDR: xeFxiMCGqjecpaiU4aU81xv5dlhwhBi2WxmNvIguZ9EqcpzpeMun6EShezOBg5zGTeF9DY7S4k
 /89whH0/1+0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="144752680"
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="144752680"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 18:28:53 -0700
IronPort-SDR: qx2p1oPmyFpV7qj2mftNsBMYxvFw0Uz7HJYUrO6I3sAC25ReEXk8vjRzPzaE1aNXU8cI4DfPnP
 wzqn7yAxt6VQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="275875386"
Received: from hluxenbu-mobl.ger.corp.intel.com (HELO localhost) ([10.252.36.218])
  by orsmga003.jf.intel.com with ESMTP; 24 Jun 2020 18:28:36 -0700
Date:   Thu, 25 Jun 2020 04:28:32 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 02/21] x86/cpufeatures: x86/msr: Add Intel SGX Launch
 Control hardware bits
Message-ID: <20200625012832.GE21758@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-3-jarkko.sakkinen@linux.intel.com>
 <20200624130434.GC8492@zn.tnic>
 <20200624143440.GD25092@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624143440.GD25092@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 24, 2020 at 07:34:40AM -0700, Sean Christopherson wrote:
> On Wed, Jun 24, 2020 at 03:04:34PM +0200, Borislav Petkov wrote:
> > On Thu, Jun 18, 2020 at 01:08:24AM +0300, Jarkko Sakkinen wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> > > Launch Control.
> > > 
> > > Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> > > SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> > > called enclaves, are always signed. All enclaves signed with the public key
> > > are unconditionally allowed to initialize. [1]
> > > 
> > > Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs
> > 
> > LE_WR or LC_ENABLED?
> 
> It should be FEAT_CTL_SGX_LC_ENABLED, i.e. the actual code is correct.  We
> updated the #define to use the SDM name to be consistent with the other bits
> and neglected to update the changelog.
> 
> Thanks!
>  
> > With that addressed:
> > 
> > Reviewed-by: Borislav Petkov <bp@suse.de>

I'll update the commit according to this information.

> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > https://people.kernel.org/tglx/notes-about-netiquette

Thank you.

/Jarkko
