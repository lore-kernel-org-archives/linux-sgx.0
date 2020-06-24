Return-Path: <SRS0=YYkI=AF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79825C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 14:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABAE20781
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 14:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390033AbgFXOem (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Jun 2020 10:34:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:47171 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388652AbgFXOel (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Jun 2020 10:34:41 -0400
IronPort-SDR: QvHnJUhpf6MGlim+c7lr5kYNft8VdOlpeUzp6nJSK2k/Ry/AdzvcxFSobIMrWJaX6CShXSqv6q
 bap02RU7XgVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="132926920"
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="132926920"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 07:34:41 -0700
IronPort-SDR: MxKSfNbXtXyBPxUZ+wmqRkvtH0JapHsGgsw21Wjg04BixpcbX7MKyi3BxaWqW9Wa++XhJ5qRSi
 TZbr29+G0MZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="265090920"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 24 Jun 2020 07:34:39 -0700
Date:   Wed, 24 Jun 2020 07:34:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
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
Message-ID: <20200624143440.GD25092@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-3-jarkko.sakkinen@linux.intel.com>
 <20200624130434.GC8492@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624130434.GC8492@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 24, 2020 at 03:04:34PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:24AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
> > Launch Control.
> > 
> > Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
> > SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
> > called enclaves, are always signed. All enclaves signed with the public key
> > are unconditionally allowed to initialize. [1]
> > 
> > Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs
> 
> LE_WR or LC_ENABLED?

It should be FEAT_CTL_SGX_LC_ENABLED, i.e. the actual code is correct.  We
updated the #define to use the SDM name to be consistent with the other bits
and neglected to update the changelog.

Thanks!
 
> With that addressed:
> 
> Reviewed-by: Borislav Petkov <bp@suse.de>
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
