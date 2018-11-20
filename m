Return-Path: <SRS0=WnBG=N7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4021AC4161D
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Nov 2018 11:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F16A020685
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Nov 2018 11:45:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F16A020685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbeKTWOV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Nov 2018 17:14:21 -0500
Received: from wind.enjellic.com ([76.10.64.91]:39803 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbeKTWOU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 20 Nov 2018 17:14:20 -0500
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2018 17:14:20 EST
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.14.3/8.14.3) with ESMTP id wAKBF93H027757;
        Tue, 20 Nov 2018 05:15:09 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.14.3/8.14.3/Submit) id wAKBF8kp027756;
        Tue, 20 Nov 2018 05:15:08 -0600
Date:   Tue, 20 Nov 2018 05:15:08 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
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
        Darren Hart <dvhart@infradead.org>, andy@infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181120111508.GA26127@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [0.0.0.0]); Tue, 20 Nov 2018 05:15:09 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 19, 2018 at 07:29:25AM -0800, Andy Lutomirski wrote:

Good morning, I hope this note finds the week going well for everyone.

> On Thu, Nov 15, 2018 at 5:08 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> >
> > SGX driver provides a ioctl API for loading and initializing enclaves.
> > Address range for enclaves is reserved with mmap() and they are
> > destroyed with munmap(). Enclave construction, measurement and
> > initialization is done with the provided the ioctl API.

> I brought this up a while back, and I think I should re-ask it now
> that this driver is getting close to ready:
>
> As it stands, there's just one SGX character device, and I imagine
> that it'll be available to unprivileged applications.  I'm concerned
> that this isn't quite what we want.  I certainly think that
> everyone, or at least almost everyone, ought to be able to run
> normal enclaves.  But I think that we should consider restricting
> who can run specially privileged enclaves.  In particular, the
> ability to run enclaves with the provisioning bit set is somewhat
> sensitive, since it effectively allows access to a stable
> fingerprint of the system.  Before flexible LC, this wasn't such a
> big deal, since only Intel's provisioning enclave could see the key,
> and Intel's enclave has some degree of control of what is done with
> the key.  With flex LC, this protection is lost.

When I saw this thread over the weekend I was going to reply to it and
raise this issue but Andy beat me to it.  Beyond that I was busy
trying to get enough firwewood ready to stay warm for the winter so
other priorities prevailed.. :-)

About 6-8 months ago, Andy and I had a lively discussion on this list
about whether or not there was a need, from a security perspective,
for enclave based LC.  I understand the sentiment against enclave
based LC, particularly with only a single vendor in control, but when
the entire spectrum of SGX security guarantees are considered, things
begin to fray at the edges a bit when LC is delegated to the kernel.

As everyone knows, in the most general sense, SGX is designed to
implement security in an IAGO threat environment, ie. where the entire
platform is compromised.  This is conceptually, if not provably
possible, when all of the security contracts are fulfilled by
enclaves.  Placing LC in the kernel has the effect of bringing the
kernel into the TCB footprint of the overall security guarantees the
technology is designed to deliver, which include privacy and
anonymity.

So, as Andy points out, we now need to work these security
considerations into the design of what will be 'the' Linux SGX driver.

Moving LC into the kernel means that rigid security controls are no
longer available for two security sensitive assets; The Provisioning
Key (PK) and the Provisioning Seal Key (PSK).

The PK is used to generate a unique Platform Provisioning IDentity
(PPID) in the Endpoint Selection (ES) phase of the Intel Enhanced
Privacy ID (EPID) provisioning protocol.  With the proposed driver, as
Andy notes above, there is now the opportunity for adversarial
generation of a unique platform identity by anyone who can create and
run an enclave.

The ENCLU[EGETKEY] instruction does not include the OWNEREPOCH values
in the key derivation process so the PK is in effect a permanent and
unique identity for a platform.

The PSK is one of the statically derived symmetric keys that are
available for sealing/encryption of data.  The PSK is used to encrypt
and protect the EPID private key that Intel provisions to a platform.
This private key is used by the quoting enclave to sign attestation
reports for enclaves running on the platform.  The SGX privacy
guarantees are a function of the security characteristics of EPID
keys.

So, loss of the PSK has implications with respect to the binding of an
EPID to a platform and what entities can use the EPID private key.  In
the enclave LC model the only entities with access to the key are the
provisioning (PVE) and quoting (QE) enclaves.

For the benefit of those not deeply involved in all this.  Shortly
after the release of the Linux SDK/PSW, Intel evolved the ability to
uniquely identify a platform and verify that an enclave is running on
a 'GenuineIntel' platform into the Platform Certification Enclave
(PCE).  This enclave has the provisioning attribute set and uses
access to the PK to implement this functionality.

Section 5.8.2 of the Costan and Devadas SGX review paper talk about
the PK and the PSK.  This section notes, in a referral to section
5.9.3, that restriction of general access to the PROVISION attribute
by enclaves is important for SGX privacy guarantees.

So I believe it is fair to state that this issue requires careful
consideration as we move the Linux SGX eco-system forward.

> But this is maybe more of a big deal than just access to a stable
> fingerprint.  The ability to provision a remote attestation protocol
> is a key part of running SGX malware, and SGX malware is surely
> going to exist some day.  (Sure, Intel will try to block access to
> the actual attestation service for malware, but I doubt that Intel
> will be able to fully defend it.)

Malware would not necessarily need the Intel attestation service.
Once access to the PROVISION bit is available, malware teams could
simply build their own attestation service.

Malware authors are a bit limited now by the general design of the
Intel PSW that mediates all enclave platform functionality through the
aesm_service binary.  The group that I direct SGX engineering for,
IDfusion, developed a complete replacement for the Intel PSW.  Our
work is a minimum footprint implementation that focuses on the
application of SGX to intelligent network endpoint devices and
embedded environments.

Our PSW supports the generation of 'fat binaries' where all of the
functionality, including enclaves, can be embedded into a single
statically linked and self-contained binary.  We developed a proof of
concept application, based on the Apache Struts vulnerability, that
loads one of these binaries on a platform which then sets up a secured
and attested channel for spirting information off of the malware
target.

So the malware concerns are not theoretical, as we are not an
extraordinarily clever group of individuals.  We are considering an
open-source release of the tooling we have developed and even if we
don't end up doing that someone else could easily implement equivalent
functionality.

We've written at some length about these issues in the following Intel
SGX developer forum threads if anyone is interested:

https://software.intel.com/en-us/forums/intel-software-guard-extensions-intel-sgx/topic/781730

https://software.intel.com/en-us/forums/intel-software-guard-extensions-intel-sgx/topic/671517

From a hardware perspective, FLC has now emerged on the Xeon E series
of processors.  FLC isn't being deployed for the sake of openness or
the open-source community, it is rather, secondary to a vertical
marketing strategy that Intel is implementing for SGX.

Intel is offering a subscription based service for data-center
applications of SGX.  Attestation is based on an ECDSA secured
certification that the enclave is running on a 'GenuineIntel' platform
with a specific platform security version (PSVN), see the discussion
on the PCE enclave above.

Non server class, ie. workstations and embedded class devices, will
presumably use a provisioning and EPID based strategy.

> So I propose that there be a few device nodes.  Maybe
> /dev/sgx/unprivilegd and /dev/sgx/provisioning?  The default mode of
> the latter could be 0600.  If you've opened the unprivileged node,
> you can only run enclaves without any special permission bits set.
>
> We should also consider whether we allow the unprivileged node to
> run launch enclaves, and, for that matter, whether we allow user
> code to run launch enclaves at all, given that they're not useful
> with the current architecture of the driver.

Doing this right is probably going to take a bit more then two
separate device nodes.

I believe what the Linux community needs to do is to step back and
consider how to create a driver architecture that supports what will
be the certain stratification of SGX hardware.  I don't see the
current driver being useful for anything but data-center class
hardware for the intermediate if not foreseeable future.

In addition, given what was detailed above, I don't see how this
driver is going to be satisfactory for those of us delivering
platforms with stringent security and privacy guarantees that are
relevant in an IAGO model.  Like it or not the most stringent security
contracts are only available in a full enclave based model.

As a result, like it or not, the current driver needs the ability to
function in both launch control modes.

> --Andy

Hopefully the above information is useful to the development dialogue.

Developing a community driver is tedious at best, particularly for
hardware such as this.  Our personal thanks to Jarkko and others who
have been working through these issues.

Best wishes for a productive remainder of the week and for a pleasant
Thanksgiving holiday for those who will be celebrating that.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"So you got your butt kicked by an 'old' guy.

 Before you taunted him did it ever cross your mind that the $1200
 Schmoelke aero-bars he was laying on and the $900 Rocket7 cycling
 shoes he was wearing might mean that the $10,000 custom bike frame he
 was riding was used for more than transportation to the Dairy Queen
 each night for a Dilly Bar?"
                                -- Dr. G.W. Wettstein
                                   Resurrection
