Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A17C433E9
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Feb 2021 12:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10BF764E15
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Feb 2021 12:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhBLMPZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Feb 2021 07:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBLMPR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Feb 2021 07:15:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D72464E13;
        Fri, 12 Feb 2021 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613132077;
        bh=510myMD6vWBAlDophgS2ciq6MWG5jVQ0CYZSshT//fQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CioZAzVVDpO5DsKv4ygntiMF4fo6P63X54JrsjtcgKlsphS9kE1pYpoSnSsL2L3U1
         QrQsSQMZV3cx12a3x2DuU54n4YlH/ZUDCqk2V2WDwUgYc+78lyungoU0KIo8zC9Zmh
         F0SzY47ZxTrRumJa+yf+OpRYkPQLSeWXNcKriusT/j26CJNGFPeqdUla/TpNbNHjRG
         Hqih3e4qHIuPBSvNJoP9DeyyA8mdsZxRBiwmERf8z2A6tyuZBPHjl861++f2SEq2d6
         yg+cxw/PJmAOAlPd6G1/OtcvHQdVIiq76gDpNQ+OKz7qZyF4+bIRA34NlhJ9cpgGuZ
         wauotrPkDjd0Q==
Date:   Fri, 12 Feb 2021 14:14:27 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YCZxI0UucOkfkU41@kernel.org>
References: <cover.1612777752.git.kai.huang@intel.com>
 <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
 <YCL8ErAGKNSnX2Up@kernel.org>
 <YCL8eNNfuo2k5ghO@kernel.org>
 <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Feb 09, 2021 at 01:36:06PM -0800, Dave Hansen wrote:
> On 2/9/21 1:19 PM, Jarkko Sakkinen wrote:
> >> Without that clearly documented, it would be unwise to merge this.
> > E.g.
> > 
> > - Have ioctl() to turn opened fd as vEPC.
> > - If FLC is disabled, you could only use the fd for creating vEPC.
> > 
> > Quite easy stuff to implement.
> 
> The most important question to me is not how close vEPC is today, but
> how close it will be in the future.  It's basically the age old question
> of: do we make one syscall that does two things or two syscalls?
> 
> Is there a _compelling_ reason to change direction?  How much code would
> we save?

I'm not really concerned about saving any code, at all. I'm more
concerned of adding unnecessary bells and whistles to uapi.

IMHO when new uapi is adding it has the burden of ensuring that it is
relevant, and necessary.

For me it like now to be frank that I'm sure, which one is the right
way to go, i.e. I'm not positioned to any side. But being unsure neither
is not a great position to ack anything.

/Jarkko
