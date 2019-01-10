Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60720C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 21:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C5BF2173B
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 21:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547156192;
	bh=mC817J8yDuvxjYFLAT67ASefkHLsvv01EkeDI0qGq9U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=18QwdglkAtZetASD9dou3Ra4lxYS5HznWoAV03C663zKHeiN2oI54can7uwGizSvp
	 jUZ5sCutmKVd08OXJXQbRvmTINyozRuvCJI7TPEC0ANLob4DYDTYE9GM+B6zawDWkF
	 8pUimXS/Z9scusjSDHMhhIJU0fpP4YHsdJVUuyt8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfAJVgb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 16:36:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbfAJVgb (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 16:36:31 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3F62183F
        for <linux-sgx@vger.kernel.org>; Thu, 10 Jan 2019 21:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547156190;
        bh=mC817J8yDuvxjYFLAT67ASefkHLsvv01EkeDI0qGq9U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=POIWfn3z+nlI7hFG/8jJ7/1iqQTUPObmoECZc97APZZ3FMMcIZ0ddOXFJJlqQnAXR
         OtCogiZJBZ3tEbIR/m46JEbTaSHRx+BWwG+9oHiKBb/tyEmZnGhBCy0z3WWprLa1/s
         PV3CLEHK+DXmrr06Vsj5VPx3b0pc0Lkx63Z5cvRs=
Received: by mail-wr1-f47.google.com with SMTP id c14so13127680wrr.0
        for <linux-sgx@vger.kernel.org>; Thu, 10 Jan 2019 13:36:29 -0800 (PST)
X-Gm-Message-State: AJcUukfyzxmoz3mVOuiYfPhMFVptzJfRhLrXJ1GR3m1F6t8P3CePrZZc
        y72rKDJI+PmebaQSx0Zo8s1h7ZqK7Lfa8vr/UjIpwg==
X-Google-Smtp-Source: ALg8bN4yDHyx4BMbc3OdTvIC4vbi93wg7vXg/btHkYc7QQ4YIawd//OAoM50u6XPtYBH2OZZl13Lp/s06gs7ZuHHqlw=
X-Received: by 2002:adf:ea81:: with SMTP id s1mr10616382wrm.309.1547156188541;
 Thu, 10 Jan 2019 13:36:28 -0800 (PST)
MIME-Version: 1.0
References: <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com> <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com> <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com> <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190110174550.GJ6589@linux.intel.com>
In-Reply-To: <20190110174550.GJ6589@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 10 Jan 2019 13:36:15 -0800
X-Gmail-Original-Message-ID: <CALCETrXMW+tUyTaMmmdhGciqbktiqH6NCuLZbBqfhcnzCgMbnA@mail.gmail.com>
Message-ID: <CALCETrXMW+tUyTaMmmdhGciqbktiqH6NCuLZbBqfhcnzCgMbnA@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
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

On Thu, Jan 10, 2019 at 9:46 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Jan 08, 2019 at 02:54:11PM -0800, Andy Lutomirski wrote:
> > I do think it makes sense to have QEMU delegate the various ENCLS
> > operations (especially EINIT) to the regular SGX interface, which will
> > mean that VM guests will have exactly the same access controls applied
> > as regular user programs, which is probably what we want.  If so,
> > there will need to be a way to get INITTOKEN privilege for the purpose
> > of running non-Linux OSes in the VM, which isn't the end of the world.
> > We might still want the actual ioctl to do EINIT using an actual
> > explicit token to be somehow restricted in a way that strongly
> > discourages its use by anything other than a hypervisor.  Or I suppose
> > we could just straight-up ignore the guest-provided init token.
>
> Does it even matter if just leave EINITTOKENKEY attribute unprivileged
> given that Linux requires that MSRs are writable? Maybe I'll just
> whitelist that attribute to any enclave?
>

I would at least make it work like the PROVISIONKEY bit (or whatever
it's called).  Or just deny it at first.  It's easy to start allowing
it if we need to down the road, but it's harder to start denying it.

Also, I don't really want to see some SDK invoke a launch enclave
because that's how it works on Windows and then do nothing with the
resulting EINITOKEN.  If we don't allow it, then the SDKs will be
forced to do a better job, which is probably a good thing.
