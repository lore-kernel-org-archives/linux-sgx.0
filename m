Return-Path: <SRS0=rlww=OC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB812C43441
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Nov 2018 10:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 899EB20659
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Nov 2018 10:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 899EB20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394192AbeKWVXk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Nov 2018 16:23:40 -0500
Received: from wind.enjellic.com ([76.10.64.91]:34591 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394186AbeKWVXk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Nov 2018 16:23:40 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.14.3/8.14.3) with ESMTP id wANAdNSt014028;
        Fri, 23 Nov 2018 04:39:24 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.14.3/8.14.3/Submit) id wANAdNqg014027;
        Fri, 23 Nov 2018 04:39:23 -0600
Date:   Fri, 23 Nov 2018 04:39:23 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@kernel.org>
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
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181123103923.GA13851@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrV4wOpk7wf9+ywd50PekGjfT7LNtwqHhcV08=oxPmKtKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV4wOpk7wf9+ywd50PekGjfT7LNtwqHhcV08=oxPmKtKQ@mail.gmail.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [0.0.0.0]); Fri, 23 Nov 2018 04:39:24 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 22, 2018 at 12:56:23PM -0800, Andy Lutomirski wrote:

Good morning to everyone.

> On Thu, Nov 22, 2018 at 3:12 AM Dr. Greg <greg@enjellic.com> wrote:
> > In addition, we are not confident
> > the driver will be useful to anything other then server class hardware
> > and will be incapable of supporting virtually all of the existing SGX
> > hardware in the field.

> I forgot to mention: I have a plain old retail Intel Celeron (I
> think -- it's not in front of me right now) that has Flex LC.  I
> suspect that, going forward, all new Intel CPUs will support Flex
> LC.  I really wish that Intel would document all of the detailed
> capabilities of all their CPUs somewhere.

Interesting, that contradicts the read we had gotten on FLC.

The only specific CPU's that we know of that are acknowledged to have
FLC are the XEON E series in support of the PCE/ECDSA attestation for
data-center use of SGX.

I'm assuming this is a really new system?  If so that matches our
experience with respect to the fact that SGX2/EDMM capable systems
slipped out quietly in early generation NUC SOC's.

Your sentinments are correct with respect to getting solid guidance on
hardware, it is a significant issue, particularly with respect to
SGX.

> There has been some talk of how the driver could support old CPUs.
> It would involve a rather different LE being signed by Intel, but it
> should be more or less transparent to user code if it happens.

I will reply to the LE and driver capability issues in my response to
your earlier e-mail so the thread does not diverge.

Jarkko, when this driver lands it will set the SGX ABI in stone for
Linux.  It would be very, very helpful to the development community if
there was some official guidance from Intel on whether or not FLC will
be a universal feature on all hardware and the date that is going to
happen or has happened.

If this turns out to be an OEM selectable issue via firmware
customizations, things will be even more problematic.

As things stand now, the proposed mainline SGX driver is going to be
useless for a lot of hardware that is out in the field.  Linux has
always had the reputation for supporting legacy hardware so this
directly contravenes that principal and needlessly so.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker
IDfusion, LLC
4206 N. 19th Ave.           Implementing measured information privacy
Fargo, ND  58102            and integrity architectures.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: gw@idfusion.org
------------------------------------------------------------------------------
"Simplicity is prerequisite for reliability."
                                -- Edsger W. Dijkstra
