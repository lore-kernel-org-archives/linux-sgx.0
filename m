Return-Path: <SRS0=zo89=OB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8C2C43441
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Nov 2018 15:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 959A720820
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Nov 2018 15:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxHHsg0P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 959A720820
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437667AbeKWCBM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Nov 2018 21:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730517AbeKWCBM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Nov 2018 21:01:12 -0500
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE75820820
        for <linux-sgx@vger.kernel.org>; Thu, 22 Nov 2018 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542900083;
        bh=PrAXY+uvMxQxYzDIlCv87TRxKZFwsa+PgJBBd1NJU6k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qxHHsg0PfdiVD4+mhjwylpy2YtfE2KqoIdyxYC8abJuQvW2p9tDRvqXLkz/PfVI2a
         7/cqAZswo6g4org1oLrK1vzsm6VS80Edi0bSE4kftbeHymn0u82zmy7IHpXNObksMx
         dAn+7FTJhFf0ZlD9E0Q0eRuKQ9Cm3ZaYT5ZYfZT8=
Received: by mail-wm1-f49.google.com with SMTP id k198so9507463wmd.3
        for <linux-sgx@vger.kernel.org>; Thu, 22 Nov 2018 07:21:22 -0800 (PST)
X-Gm-Message-State: AA+aEWY5+rVyjXmJ6+S1TOVKFrQt07mKkVae5xF3fE8qP7oestGVyi1J
        0KSQD8Zz26yNqi0fAoaFBw6D80AM+0bHg7eVSRhPOg==
X-Google-Smtp-Source: AFSGD/XfxMe9HPcOV+K9UgrWgR505Pt6dffhPVquS7r4WTvr7u1z/k023djUte3ft5gJtow1OG13S/ckBJTC9POm6Dk=
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr3561460wmc.74.1542900081182;
 Thu, 22 Nov 2018 07:21:21 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com>
In-Reply-To: <20181122111253.GA31150@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 22 Nov 2018 07:21:08 -0800
X-Gmail-Original-Message-ID: <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
Message-ID: <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     "Dr. Greg Wettstein" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 22, 2018 at 3:12 AM Dr. Greg <greg@enjellic.com> wrote:
>
> On Tue, Nov 20, 2018 at 02:04:42PM +0200, Jarkko Sakkinen wrote:
>
> Good morning to everyone, Happy Thanksgiving to those who are
> celebrating the holiday.
>
> > On Mon, Nov 19, 2018 at 08:59:24AM -0800, Andy Lutomirski wrote:
> > > The idea here is that, under normal circumstances, provisioning only
> > > runs once, or at least only runs rarely.  So, rather than the SDK
> > > running provisioning whenever it feels like doing so (which is the
> > > current behavior, I imagine, although I haven't looked), there would
> > > be a privileged program, perhaps a systemd unit that runs when needed,
> > > that produces the key material needed for remote attestation, and
> > > non-root users that need attestation would get the keying material
> > > from the provisioning service.  And the provisioning service could
> > > implement its own policy.  Ideally, the service wouldn't give the
> > > sealed keys to users at all but would, instead, just provide the
> > > entire attestation service over a UNIX socket, which would make
> > > provisioning capabilities revocable.
> > >
> > > Does this make sense?
>
> > Yes, it does for me at least now that you brought some context.
>
> Let me see if I can add a bit of additional context to the above to
> frame further discussion regarding two major needs of the driver
> before it lands.
>
> What Andy is describing is how the current system already works.  The
> driver is at the root of a fairly complex eco-system of code,
> cryptography and protocols that implement SGX functionality.  This
> software stack is known as the SGX Platform SoftWare (PSW) or SGX
> runtime.
>
> The Intel provided runtime is implemented in C++ and, depending on how
> you count it, clocks in at around 50+ KLOC.  All of this ends up as a
> single 1.8 megabyte binary named aesm_service that links against 35
> shared libraries and is run by systemd.
>
> This binary implements the functionality needed to load, initialize,
> run and attest enclaves.  It also implements communications with the
> Intel provisioning and attestation services which is needed to
> provision a private EPID key to the platform and to verify the status
> of an enclave attestation quote from a remote platform.
>
> In order to achieve the SGX/IAGO security model, a lot of this
> functionality is implemented by choreographing exchanges between six
> Intel supplied and signed enclaves.  Intel supplies source code to
> these enclaves and understanding how all of this works requires an
> understanding of that codebase as well.  To top if off there is also a
> 50K hunk of signed Java bytecode that gets stuffed into the Management
> Engine if you are interested in platform services.
>

It's very nice of Intel to supply source. Also, yikes, they wrote
their ME blob in Java?

> All of the above is what we wrote an independent implementation of, in
> straight C, that is capable of linking against the MUSL C library with
> only libelf and OpenSSL as dependencies.  We developed all of this to
> support a reasonably sophisticated multi-enclave SGX security
> application that implements modeling the runtime behavior of
> applications running on the Linux kernel.  That application uses an
> alternate enclave attestation and communications architecture that we
> independently developed.

How do you generate your root of trust for attestation if you don't
use Intel's service?  If I understand right, Intel's mechanism boils
down to Intel possessing something that is functionally equivalent to
a list of valid provisioning keys associated with genuine Intel chips.
(It could be literal provisioning keys, or keying material from which
the provisioning keys are derived, or even public keys for which the
private parts are derived from the provisioning keys.  But all of this
boils down to the CPU, via some enclaves, proving knowledge of the
provisioning key that is available when MRSIGNER is Intel.

I could imagine replacing this by running Intel's mechanism once to
generate a new root of trust for your own mechanism, or even by buying
a bunch of CPUs, determining their provisioning keys with MRSIGNER=Dr.
Greg, and enrolling those.  But I don't see any way to bootstrap an
attestation service on a CPU you've never physically possessed without
running *something* with MRSIGNER=Intel.

> Based on this experience, if the proposed driver lands in its current
> state, Linux mainline will have, at least from a privacy perspective,
> an inferior implementation of SGX.  In addition, we are not confident
> the driver will be useful to anything other then server class hardware
> and will be incapable of supporting virtually all of the existing SGX
> hardware in the field.

I'm a little bit puzzled by your privacy claims.  If an attacker
controls the kernel, then the secrets in your enclave may still be
secure, but you have very little privacy in terms of trying to prevent
the attacker from tying your communication to your physical machine.

> At a high level, addressing these issues is straight forward.  First,
> the driver needs to support authorization equivalent to that which is
> implemented in the current Intel Launch Enclave, ie. control over the
> SGX_FLAGS_PROVISION_KEY attribute.

I agree, hence my email :)

> Secondly, the driver needs to drop
> its prohibition against launch enclaves, ie. returning EINVAL when a
> request is made to initialize enclaves which have the
> SGX_FLAGS_EINITTOKEN_KEY attribute set.
>

Can you explain your use case for a launch enclave?  The current
driver won't allow you to supply an EINITTOKEN, so I'm not immediately
seeing what you would do with a launch token.  If you really do need
it, I suppose we could have 'unprivileged', 'provisioning', and
'launch' nodes, and maybe even 'launch_and_provision', but that's
starting to have some combinatorial issues.
