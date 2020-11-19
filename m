Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2D0C56201
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 16:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5249222227
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Nov 2020 16:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFubcAiN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgKSQo4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbgKSQoz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Nov 2020 11:44:55 -0500
Received: from kernel.org (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB0922227;
        Thu, 19 Nov 2020 16:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605804295;
        bh=JrlDSPksqsrhvKz/XEGkZgqwYNlCAulpC3b93P4lP+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DFubcAiN/HnXnULVYGy+hFMjqaDYqSLPOkCUirUvlm8c/mExFHOf6v7Niqo73xNMA
         N9ECvAnID09j5UMTyq9WOxq+A22wC/pj7gTrTiTDdhm3zho9KBqlYFOirRN2CGbYe8
         xj93KKssVByFllLSlpQncL3uqzb+qF3rzwKvyjN8=
Date:   Thu, 19 Nov 2020 18:44:46 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Borislav Petkov <bp@alien8.de>, linux-sgx@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH] selftests/x86: Fix malformed src_offset initialization
Message-ID: <20201119164446.GB77509@kernel.org>
References: <20201118215446.GO7472@zn.tnic>
 <AA92701F-05C7-4551-9C26-39946CC55B0A@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AA92701F-05C7-4551-9C26-39946CC55B0A@amacapital.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 18, 2020 at 05:16:53PM -0800, Andy Lutomirski wrote:
> 
> 
> > On Nov 18, 2020, at 1:54 PM, Borislav Petkov <bp@alien8.de> wrote:
> > 
> > ﻿On Wed, Nov 18, 2020 at 11:37:55PM +0200, Jarkko Sakkinen wrote:
> >> Just checking that I got this right: you want me to port my anon inode
> >> changes from March to be applied on top of tip and send them?
> > 
> > Well, we need to somehow address the issue when some distros map /dev
> > noexec and that is conflicting with SGX due to it needing to mmap with
> > executable permissions but /dev/sgx_enclave is noexec...
> > 
> > I guess the first thing that needs figuring out is why are some distros
> > mounting /dev noexec.
> > 
> > I mean, you can always do the easiest thing: somewhere in the SGX
> > docs say that one of the steps towards running SGX enclaves on such
> > distros is for the admin to map /dev exec. However, does that have other
> > security implications which would make such exec mounting a security
> > hazard?
> > 
> > If so, then the SGX code would need changing...
> > 
> > Questions like those.
> 
> I thought we had determined that this was solvable entirely in
> userspace.  Udev can handle this, no?

Check my response to Boris.

In that seame thread you said that you would post to udev mailing list
about the matter? Did you ever got around? Not sure if it matters
though. I think we have reasonable information that this is the right
solution.

https://lore.kernel.org/linux-sgx/CALCETrVBO8ceeT8qXw2rDQgdzJH8U-YLpYNMDGC0VudD4VgTCQ@mail.gmail.com/


> > 
> > HTH.
> > 
> > -- 
> > Regards/Gruss,
> >    Boris.
> > 
> > https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
