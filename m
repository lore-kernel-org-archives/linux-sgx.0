Return-Path: <SRS0=n9z9=PB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71133C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CBC2054F
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbeLXLwI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:52:08 -0500
Received: from mga12.intel.com ([192.55.52.136]:37841 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbeLXLwI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Dec 2018 06:52:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2018 03:52:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,392,1539673200"; 
   d="scan'208";a="120734283"
Received: from dlu2-mobl4.ccr.corp.intel.com (HELO localhost) ([10.249.254.240])
  by orsmga002.jf.intel.com with ESMTP; 24 Dec 2018 03:52:02 -0800
Date:   Mon, 24 Dec 2018 13:52:01 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181224115201.GA10971@linux.intel.com>
References: <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181220103204.GB26410@linux.intel.com>
 <20181222081649.GB8895@linux.intel.com>
 <20181222082502.GA13275@linux.intel.com>
 <20181223125114.GA7051@linux.intel.com>
 <CALCETrXhuVx3oFUUr5KRGPXrEpcUPjFXapLdHYJZ8C+91woh_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXhuVx3oFUUr5KRGPXrEpcUPjFXapLdHYJZ8C+91woh_Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Dec 23, 2018 at 12:42:48PM -0800, Andy Lutomirski wrote:
> On Sun, Dec 23, 2018 at 4:52 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Sat, Dec 22, 2018 at 10:25:02AM +0200, Jarkko Sakkinen wrote:
> > > On Sat, Dec 22, 2018 at 10:16:49AM +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Dec 20, 2018 at 12:32:04PM +0200, Jarkko Sakkinen wrote:
> > > > > On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
> > > > > > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > > > > > opening a new instance of /dev/sgx for each encalve?
> > > > >
> > > > > I think that fits better to the SCM_RIGHTS scenario i.e. you could send
> > > > > the enclav to a process that does not have necessarily have rights to
> > > > > /dev/sgx. Gives more robust environment to configure SGX.
> > > >
> > > > Sean, is this why you wanted enclave fd and anon inode and not just use
> > > > the address space of /dev/sgx? Just taking notes of all observations.
> > > > I'm not sure what your rationale was (maybe it was somewhere). This was
> > > > something I made up, and this one is wrong deduction. You can easily
> > > > get the same benefit with /dev/sgx associated fd representing the
> > > > enclave.
> > > >
> > > > This all means that for v19 I'm going without enclave fd involved with
> > > > fd to /dev/sgx representing the enclave. No anon inodes will be
> > > > involved.
> > >
> > > Based on these observations I updated the uapi.
> > >
> > > As far as I'm concerned there has to be a solution to do EPC mapping
> > > with a sequence:
> > >
> > > 1. Ping /dev/kvm to do something.
> > > 2. KVM asks SGX core to do something.
> > > 3. SGX core does something.
> > >
> > > I don't care what the something is exactly is, but KVM is the only sane
> > > place for KVM uapi. I would be surprised if KVM maintainers didn't agree
> > > that they don't want to sprinkle KVM uapi to random places in other
> > > subsystems.
> >
> > The one option to consider to do would be to have a device driver for
> > KVM if you really want this e.g. something like /dev/vsgx. With the
> > current knowledge I'm not yet sure why all could not be done just
> > through /dev/kvm.
> >
> 
> That seems reasonable too.  I don't really care about the path to the
> device node, but it does seem reasonable to me to have it be a
> separate node entirely from the normal enclave interface.

What is the core reason anyway that /dev/kvm is out of the question?

/Jarkko
