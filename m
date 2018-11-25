Return-Path: <SRS0=mkZ9=OE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF6BC43441
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 18:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D0562084E
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 18:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D0562084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbeKZFrx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Nov 2018 00:47:53 -0500
Received: from wind.enjellic.com ([76.10.64.91]:55198 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbeKZFrx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Nov 2018 00:47:53 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wAPItQXe023440;
        Sun, 25 Nov 2018 12:55:26 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wAPItOvT023439;
        Sun, 25 Nov 2018 12:55:24 -0600
Date:   Sun, 25 Nov 2018 12:55:24 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg Wettstein" <greg@enjellic.com>, X86 ML <x86@kernel.org>,
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
Message-ID: <20181125185524.GA23224@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sun, 25 Nov 2018 12:55:26 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 25, 2018 at 08:22:35AM -0800, Andy Lutomirski wrote:

Good morning to everyone, I hope the weekend continues to proceed
well.

Proposal follows below for kernel based policy management of enclaves
if people want to skip forward.

> >> On Nov 25, 2018, at 6:53 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> >> 
> >> On Sat, Nov 24, 2018 at 09:21:14AM -0800, Jarkko Sakkinen wrote:
> >> On Thu, Nov 22, 2018 at 07:21:08AM -0800, Andy Lutomirski wrote:
> >>>> At a high level, addressing these issues is straight forward.  First,
> >>>> the driver needs to support authorization equivalent to that which is
> >>>> implemented in the current Intel Launch Enclave, ie. control over the
> >>>> SGX_FLAGS_PROVISION_KEY attribute.
> >>> 
> >>> I agree, hence my email :)
> >> 
> >> Started to scratch my head that is it really an issue that any enclave
> >> can provision in the end?
> >> 
> >> Direct quote from your first response:
> >> 
> >> "In particular, the ability to run enclaves with the provisioning bit set
> >> is somewhat sensitive, since it effectively allows access to a stable
> >> fingerprint of the system."
> >> 
> >> As can be seen from the key derivation table this does not exactly hold
> >> so you should refine your original argument before we can consider any
> >> type of change.
> >> 
> >> I just don't see what it is so wrong for any enclave to be able to tell
> >> that it really is an enclave.

> > I mean I can understand why Greg wants LE although I don't understand
> > what benefit does it bring to anyone to lock in for enclave to allow
> > to identify itself.
> > 
> > What you are proposing does not really bring any additional security if
> > we consider a threat model where the kernel is an adversary but it makes
> > the software stack more clanky to use.

> Agreed. What I'm proposing adds additional security if the kernel is
> *not* compromised.

Let me use this to stress a concept that I believe is important in
this discussion.

SGX is enabling technology that allows developers to create software
architectures that will deliver their stated security and privacy
guarantees irrespective of platform state.  It does this by linking
'islands' of execution (enclaves) together through a web of
cryptographic guarantees.

The notion of a launch enclave is critical to establishing these
guarantees.  As soon as the kernel becomes involved in implementing
SGX security policy the architecture becomes vulnerable to kernel
and/or privilege modification attacks.

We've talked at length about the provisioning bit, I won't go into
details unless people are interested, but the EPID provisioning
protocol implements an SGX mediated cryptographic contract that a
perpetual platform identifier will not be disclosed to anyone but
Intel.  The launch enclave is critical to that guarantee.

It is completely understandable why a locked down, (non-FLC) hardware
platform, is undesirable in this community.  That doesn't mean that a
launch enclave as a concept is unneeded or necessarily evil.

In an FLC environment the kernel assumes responsibility for SGX
privacy and security.  This means that we need to do at least as well
with a kernel based model as to what is currently available.

> There are other ways to accomplish it that might be better in some
> respects.  For example, there could be /dev/sgx and
> /dev/sgx_rights/provision.  The former exposes the whole sgx API,
> except that it doesn???t allow provisioning by default. The latter
> does nothing by itself. To run a provisioning enclave, you open both
> nodes, then do something like:
>
> ioctl(sgx, SGX_IOC_ADD_RIGHT, sgx_provisioning);
>
> This requires extra syscalls, but it doesn't have the combinatorial
> explosion problem.

Here is a proposal for the driver to add the needed policy control
that is 'SGXy' in nature.  The 'SGXy' way is to use MRSIGNER values as
the currency for security policy management.

The driver should establish the equivalent of three linked lists,
maintainable via /sysfs pseudo-files or equivalent plumbing.  The
lists are referenced by the kernel to enforce the following policies.

1.) The right to initialize an enclave without special attributes.

2.) The right to initialize an enclave with the PROVISION_KEY attribute set.

3.) The right to initialize an enclave with the LICENSE_KEY attribute set.

The lists are populated with MRSIGNER values of enclaves that are
allowed to initialize under the specified conditions.

The driver should either establish a 'seal' file or value,
ie. MRSIGNER value of all zero's, that once written will not allow
further modifications of the list(s).  This will allow
cryptographically guaranteed policies to be setup at early boot that
will limit the ability of subsequent DAC compromises to affect policy
management.

The lists are obviously vulnerable to a kernel compromise but the
vulnerability scope is significantly limited vs. 'can I get root or
some other userid'.  If we are really concerned about the scope of
that vulnerability there could be an option on TPM based systems to
verify a hash value over the lists once sealed on each enclave
initialization.  We have already conceded that EINIT isn't going to be
any type of speed daemon.

On an FLC system the driver verifies that the submitted enclave has an
MRSIGNER value on one of the lists consistent with the attributes of
the enclave before loading the value into the identity modulus
signature registers.

In this model, I would argue that the driver does not need to
arbitrarily exclude launch enclaves as it does now, since the kernel
has the ability to specify acceptable launch enclaves.  The driver API
can alaso continue to accept an EINITTOKEN which maintains
compatibility with the current ABI.  Punishment can be inflicted on
non-FLC hardware owners by issueing EINVAL if an EINITTOKEN is
specified on platforms with fixed launch keys.

This also has the effect of allowing multiple launch enclaves at the
platform owner's discretion.  I know there was some sentiment, and
Jarkko had code, that used a launch enclave at a fixed location such
as /lib/firmware.  That has the disadvantage of requiring that the
kernel know about all the different ways that a launch enclave might
be used or setup.  It also establishes a cryptographic rather then a
filesystem based guarantee on the launch enclave being used.

If the lists are empty the kernel simply proceeds as it does now and
loads any enclave submitted to it.

I believe this architecture has a number of merits.  It largely
preserves compatibility with current PSW's and provides a mechanism
for cryptographically enforced policy that is consistent with the SGX
architecture.

I need to get Christmas lights put up on the house for the squirrels
to eat so I will leave this proposal open for debate.

Have a good remainder of the weekend or whats left of it.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Some of them are.  A surprising number aren't.  A personal favorite of
 mine was the log from a cracker who couldn't figure out how to untar
 and install the trojan package he'd ftped onto the machine.  He tried a
 few times, and then eventually gave up and logged out."
                                -- Nat Lanza
