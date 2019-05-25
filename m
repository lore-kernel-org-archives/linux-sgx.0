Return-Path: <SRS0=U+kW=TZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC583C07542
	for <linux-sgx@archiver.kernel.org>; Sat, 25 May 2019 17:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913B020815
	for <linux-sgx@archiver.kernel.org>; Sat, 25 May 2019 17:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfEYRds (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 25 May 2019 13:33:48 -0400
Received: from wind.enjellic.com ([76.10.64.91]:33738 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfEYRds (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 25 May 2019 13:33:48 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x4PHVHAU026665;
        Sat, 25 May 2019 12:31:17 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x4PHVDl4026664;
        Sat, 25 May 2019 12:31:13 -0500
Date:   Sat, 25 May 2019 12:31:13 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190525173113.GA25854@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com> <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com> <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com> <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com> <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com> <20190524200333.GF365@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524200333.GF365@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 25 May 2019 12:31:17 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 01:03:33PM -0700, Sean Christopherson wrote:

Good morning, I hope the weekend is going well for everyone.  Skunky
holiday weather out here in West-Central Minnesota.

> On Fri, May 24, 2019 at 12:37:44PM -0700, Andy Lutomirski wrote:
> > If we go this route, the only substantial change to the existing
> > driver that's needed for an initial upstream merge is the maxperm
> > mechanism and whatever hopefully minimal API changes are needed to
> > allow users to conveniently set up the mappings.  And we don't need to
> > worry about how to hack around mprotect() calling into the LSM,
> > because the LSM will actually be aware of SGX and can just do the
> > right thing.

> This doesn't address restricting which processes can run which
> enclaves, it only allows restricting the build flow.  Or are you
> suggesting this be done in addition to whitelisting sigstructs?
>
> What's the value prop beyond whitelisting sigstructs?
> Realistically, I doubt LSMs/users will want to take the performance
> hit of scanning the source bytes every time an enclave is loaded.
>
> We could add seomthing like security_enclave_mprotect() in lieu of
> abusing security_file_mprotect(), but passing the full source bytes
> seems a bit much.

It would seem that we hold the moniker of responsibility for this
conversation, since without our provocation regarding cryptographic
verification of enclave source, there would be a driver headed
upstream whose only constraint against W^X sourced executable code,
running with full confidentiality and integrity protections, would be
a character device with o666 permissions.  Given that, a couple of
reflections to facilitate further conversation, if nothing else for
the benefit of Jonathan Corbet and his bystanders... :-)

As the conversations to date have indicated, imposing LSM controls on
enclave executable code is a bit problematic, in no small part since
it is the theological equivalent of driving a square peg into a round
hole.  SGX, as a technology, was designed around the concept of
cryptographic verification of code provenance and origin.

The decision to take that off the table, for reasons of political
idealogy only, means that mainstream Linux will not be a platform that
can achieve the full hardware security capabilities and protections of
SGX, nor will mainstream Linux be able to enjoy full protections from
the technology itself.

We will be dealing with that, from a driver and runtime perspective,
but that is a conversation for another day.

The issue of SGX2 and Enclave Dynamic Memory Management (EDMM) has
come up and to date there doesn't appear to have been a serious
conversation regarding whether or not all of the LSM machinations in
the world will make any difference when this technology goes mainline.
The agenda driving mainlining of the driver is to support Graphene for
cloud based solutions and without EDMM, dynamic code loading support
is decidedly more problematic.

Dynamic enclave code loading isn't problematic from a security
perspective when the code is being loaded from the platform itself,
since presumably, the encompassing conversation will result in LSM
controls being applied to the necessary code paths.  However, with the
ability to exploit SGX2 instructions, an enclave with adverserial
intent could simply setup a mutually attested security context and
pull whatever executable code it wants from the INTERNET at large,
using an encrypted and integrity protected communications channel.

That has at least been our interpretation and experience with the
ENCLU[EMODPE] and ENCLU[EACCEPTCOPY] instructions and the out-of-tree
driver.  Given the use of an encrypted channel, and the fact that
these instructions are ring 3 enclave mode only, it would seem that
all of the LSM controls in the world won't have visibility or control
over code that is being loaded and executed using such a mechanism.

We could have arguably missed something that the new driver will do to
address this issue.  To date the only discussion seems to have been
about controls over ENCLS[EAUG], which are arguably a bit blunt for
this purpose.

In the land of SGX, if one is intellectually honest from an
engineering perspective, the only solid security contract one has to
work with is the notion of cryptographic identity.  Hence our concern
and patches that implemented an absolutely minimal footprint ring-0
control infrastructure over the contents of an enclave's SIGSTRUCT.
Which is where we have arguably circled back to after 3-4 months and
one kernel release cycle.

Wrapping an LSM hook around our policy mechanism would seem to
achieve, from a security perspective, about the same level of security
effect that more major and invasive modifications would achieve, given
Cedric's proposal to inherit page permissions from the source, which
is what our runtime already does.

As always, apologies for excessive verbosity beyond LKML sensibilities.

Best wishes for a pleasant remainder of the spring weekend to
everyone.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Heaven goes by favor.  If it went by merit, you would stay out and your
 dog would go in."
                                -- Mark Twain
