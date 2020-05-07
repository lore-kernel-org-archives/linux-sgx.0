Return-Path: <SRS0=jkgx=6V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399F6C28CBC
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 00:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F9D62075A
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 00:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgEGAlu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 May 2020 20:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgEGAlu (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 6 May 2020 20:41:50 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD5C061A0F;
        Wed,  6 May 2020 17:41:50 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jWUbT-0006e2-IH; Thu, 07 May 2020 02:41:31 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id DE860102652; Thu,  7 May 2020 02:41:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Dr. Greg" <greg@enjellic.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
In-Reply-To: <20200426165753.GA11046@wind.enjellic.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <20200426165753.GA11046@wind.enjellic.com>
Date:   Thu, 07 May 2020 02:41:30 +0200
Message-ID: <87d07gk24l.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Greg,

"Dr. Greg" <greg@enjellic.com> writes:
> As an aside, for those who haven't spent the last 5+ years of their
> life working with this technology.  SGX2 hardware platforms have the
> ability to allow unrestricted code execution in enclave context.

Unrestricted code execution even before loaded? Unrestricted by
priviledge levels?

> No amount of LSM or IMA interventions can provide any control over
> that.

They can restrict what is started and loaded before anything SGX
happens.

If you want to make real technical arguments then please be specific and
precise and spare us the handwaving marketing speak.

> In fact, the Confidential Computing Consortium, sponsored by none
> other then the Linux Foundation, has at its fundamental tenant,

And that's relevant to the technical question in which way?

> the notion of developing an eco-system that allows the execution of
> code and processing of data, over which, the owner or administrator of
> the platform has no visibility or control.  It would seem only logical
> that adversarial interests would indulge themseleves in those
> capabilities as well.
>
> With respect to SGX and these issues, cryptographic policy management
> is important for the same reason that 2-factor authentication is now
> considered standard practice in the security industry.
>
> We appreciate, Jarkko, that you feel that such infrastructure is
> optional, like virtualization support, and is something that can go in
> after the driver is mainlined.  As the diffstat for our patch points
> out, the proposed support has virtually no impact on the driver, the
> same cannot be said for virtualization capabilities.

The diffstat of your patch is irrelevant. What's relevant is the fact
that it is completely unreviewed and that it creates yet another user
space visible ABI with a noticable lack of documentation. 

> Moreover, adding support for key based policy management later would
> require the addition of another ioctl in order to avoid ABI
> compatibility issues.

And that's a problem because? 

> The current initialization ioctl is best suited, from an engineering
> perspective, to support this type of infrastructure.

What's wrong with having IOCTL_INIT_TYPE_A and IOCTL_INIT_TYPE_B?

Nothing at all. It's pretty straight forward and in fact a better
solution than a duct taped multiplexing all in one IOCTL_INIT_PONIES
approach.

> In fact, the necessary support was removed from the ioctl for
> political reasons rather then for any valid engineering rationale on
> flexible launch control platforms, particularly with our patch or an
> equivalent approach.

You're surely making a convincing technical argument by claiming that
this was a political decision. The amount of non-technical, i.e.
political arguments in your mail is definitely larger than the technical
content.

> Hopefully this is a reasoned technical approach to what has been a
> long standing issue surrounding this technology.

It's an approach which guarantees that the driver will miss the next
merge window. If that's your intention, then please let us know.

Merging the current set of patches does not prevent anything you want to
be added. It's an extension to the base implementation and not a
prerequisite.

> Best wishes for a productive week.
>
> Dr. Greg

Thanks a lot for the best wishes. Unfortunately reading this email was
not necessarily productive for me, but I surely wish that you can make
productive use of my reply.

Thanks,

	tglx

> ------------------------------------------------------------------------------
> "Opportunity is missed by most people because it is dressed in overalls
>  and looks like work."
>                                 -- Thomas Edison

------------------------------------------------------------------------------
 "Failure is simply the opportunity to begin again, this time more
  intelligently"

				--  Henry Ford
