Return-Path: <SRS0=9ERu=PA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB86C43387
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Dec 2018 20:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2B47217D7
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Dec 2018 20:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545597782;
	bh=XWloAgP0FimDnwcL2BUy6GJT3cfzyDOhnds0UkaNybQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KnJjgQV2OeSkKgdkKHStrEJMVn/83jLUjWNLj7mVwrgB288ej+ZCzYujF86xAJh6e
	 22JA2BI/PIkqK95pjSaZyOrzDsg82t0We1FnxZ1ieaAN7Fo+cIp4wicrxQdGZcV8HX
	 H7pToC8MFK/oSrL6eCQyJ/hgGQEmYSMzKikPEE/Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbeLWUnC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Dec 2018 15:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbeLWUnC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Dec 2018 15:43:02 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C2F218D8
        for <linux-sgx@vger.kernel.org>; Sun, 23 Dec 2018 20:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545597781;
        bh=XWloAgP0FimDnwcL2BUy6GJT3cfzyDOhnds0UkaNybQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YnxwSVxWl05U9WKyzfP3iXJFV9jtY01GKPVmSqO9P5sC0XB7r2T6tZu4M3D3tg1vM
         czmdxw/lw9QjtNYQdT6x0EuHbV0C9YDPFZtQ2oSw8U2xf5hq45aI9DZY2ZT91gLBWB
         TWXrwqoFRGHrdPIlrEk9++5MJ5i9KCIms+w174xE=
Received: by mail-wm1-f43.google.com with SMTP id b11so9867297wmj.1
        for <linux-sgx@vger.kernel.org>; Sun, 23 Dec 2018 12:43:00 -0800 (PST)
X-Gm-Message-State: AJcUukeWuqaNc9pb8HnKVaTx56H75Buu8cAElNHfnR4bKXbgC+UT3Z2v
        2OEEs3r3BLtT9Arr80POQfsYvcilTiS7uiFLsh1OAw==
X-Google-Smtp-Source: AFSGD/XlkK/oNtDFZc+Wje5CTyDu6DUBEjhrkmj9Ddr2xiLcOY1DOQZTFnMEkmAKsEEEiLADF4Lqk+AgUrrl0RNWB+A=
X-Received: by 2002:a1c:aa0f:: with SMTP id t15mr9809530wme.108.1545597779143;
 Sun, 23 Dec 2018 12:42:59 -0800 (PST)
MIME-Version: 1.0
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com> <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181220103204.GB26410@linux.intel.com> <20181222081649.GB8895@linux.intel.com>
 <20181222082502.GA13275@linux.intel.com> <20181223125114.GA7051@linux.intel.com>
In-Reply-To: <20181223125114.GA7051@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 23 Dec 2018 12:42:48 -0800
X-Gmail-Original-Message-ID: <CALCETrXhuVx3oFUUr5KRGPXrEpcUPjFXapLdHYJZ8C+91woh_Q@mail.gmail.com>
Message-ID: <CALCETrXhuVx3oFUUr5KRGPXrEpcUPjFXapLdHYJZ8C+91woh_Q@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Dec 23, 2018 at 4:52 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Sat, Dec 22, 2018 at 10:25:02AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Dec 22, 2018 at 10:16:49AM +0200, Jarkko Sakkinen wrote:
> > > On Thu, Dec 20, 2018 at 12:32:04PM +0200, Jarkko Sakkinen wrote:
> > > > On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
> > > > > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > > > > opening a new instance of /dev/sgx for each encalve?
> > > >
> > > > I think that fits better to the SCM_RIGHTS scenario i.e. you could send
> > > > the enclav to a process that does not have necessarily have rights to
> > > > /dev/sgx. Gives more robust environment to configure SGX.
> > >
> > > Sean, is this why you wanted enclave fd and anon inode and not just use
> > > the address space of /dev/sgx? Just taking notes of all observations.
> > > I'm not sure what your rationale was (maybe it was somewhere). This was
> > > something I made up, and this one is wrong deduction. You can easily
> > > get the same benefit with /dev/sgx associated fd representing the
> > > enclave.
> > >
> > > This all means that for v19 I'm going without enclave fd involved with
> > > fd to /dev/sgx representing the enclave. No anon inodes will be
> > > involved.
> >
> > Based on these observations I updated the uapi.
> >
> > As far as I'm concerned there has to be a solution to do EPC mapping
> > with a sequence:
> >
> > 1. Ping /dev/kvm to do something.
> > 2. KVM asks SGX core to do something.
> > 3. SGX core does something.
> >
> > I don't care what the something is exactly is, but KVM is the only sane
> > place for KVM uapi. I would be surprised if KVM maintainers didn't agree
> > that they don't want to sprinkle KVM uapi to random places in other
> > subsystems.
>
> The one option to consider to do would be to have a device driver for
> KVM if you really want this e.g. something like /dev/vsgx. With the
> current knowledge I'm not yet sure why all could not be done just
> through /dev/kvm.
>

That seems reasonable too.  I don't really care about the path to the
device node, but it does seem reasonable to me to have it be a
separate node entirely from the normal enclave interface.
