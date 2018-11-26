Return-Path: <SRS0=Z3oH=OF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E80DC43610
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 11:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DFF320817
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Nov 2018 11:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DFF320817
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbeKZVzV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Nov 2018 16:55:21 -0500
Received: from wind.enjellic.com ([76.10.64.91]:55278 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730165AbeKZVzT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Nov 2018 16:55:19 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wAQB0dJP028225;
        Mon, 26 Nov 2018 05:00:39 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wAQB0dh5028224;
        Mon, 26 Nov 2018 05:00:39 -0600
Date:   Mon, 26 Nov 2018 05:00:39 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <20181126110038.GA27609@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181125185524.GA23224@wind.enjellic.com> <D45BC005-5064-4C75-B486-4E43C454E2F6@amacapital.net> <94154ECB-3EF7-4A37-9057-0B84DBCE650E@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94154ECB-3EF7-4A37-9057-0B84DBCE650E@amacapital.net>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Mon, 26 Nov 2018 05:00:39 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 25, 2018 at 04:37:00PM -0800, Andy Lutomirski wrote:

> Bah, I hit send on a partially written draft. I???ll try again soon.
> 
> --Andy

Your first issue seems to be complete so I will respond to that in
order to make sure we are not talking past one another.

> > On Nov 25, 2018, at 1:59 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> On Nov 25, 2018, at 10:55 AM, Dr. Greg <greg@enjellic.com> wrote:
> >> 
> >> The notion of a launch enclave is critical to establishing these
> >> guarantees.  As soon as the kernel becomes involved in implementing
> >> SGX security policy the architecture becomes vulnerable to kernel
> >> and/or privilege modification attacks.
> >> 
> >> We've talked at length about the provisioning bit, I won't go into
> >> details unless people are interested, but the EPID provisioning
> >> protocol implements an SGX mediated cryptographic contract that a
> >> perpetual platform identifier will not be disclosed to anyone but
> >> Intel.  

> As a reviewer, and as an occasional academic cryptographer, I need
> to put my foot down here.  This is inaccurate.

I certainly wouldn't try to engage in a debate at the level of
academic cryptography, so I want to clarify that I was speaking
specifically with respect to the ability to use the Intel supplied
Platform Certification Enclave (PCE) to obtain a perpetual platform
identifier.

There could certainly be an academic level weakness in SGX, or in the
provisioning protocol, but at the end of the day the important issue
seems to be whether or not a PCE enclave can be exploited by anyone
with execution access to the enclave to generate a perpetual
identifier for a platform.

> There is an SGX-mediated contract that says:
>
> 1. For any given public key p, a perpetual platform identifier ID_p
> exists and will only be disclosed to the holder of the corresponding
> private key p_priv or to someone to whom the private key holder
> permits (intentionally or otherwise) to use that identifier.
>
> 2. The ability described in #1 is available to anyone whom the
> kernel and launch enclave (if the MSRs are locked ) permits
> (intentionally or otherwise) to use it.

Let me see if I can respond directly to point two as it seems the most
important.

In the EPID provisioning model, the PCE and the ProVisioning Enclave
(PVE) both have posession of the PROVISION attribute and thus access
to the derivation of an MRSIGNER specific provisioning key.

The Intel supplied launch enclave (LE) specifically denies
initialization of enclaves which have the PROVISION attribute set,
with the exception of enclaves whose MRSIGNER values match those of
the keys that Intel uses to sign the PCE and PVE enclaves.  See line
219 of psw/ae/le/launch_enclave.cpp in the Intel SDK.

In the message one phase of the provisioning protocol Intel supplies
the platform with a 3K RSA public key (PEK).  The identity of that key
is confirmed by an ECC256 based signature over the key.  Intel embeds
the public gx and gy curve points for the signature key in their SDK,
see ae/data/constants/linux/peksk_pub.hh.

The PVE verifies the signature of the PEK and generates a SHA256
verification hash over a message containing the key and uses that as
the data field in an attestation report that is generated against the
target information for the PCE.  The PVE rejects generation of the
report if the PCE target information does not have the PROVISION
attribute set.  See line 124 of psw/ae/pve/provision_msg1.cpp.

This report, along with the PEK, is submitted to the PCE enclave in
order to generate the Platform Provisioning IDentity (PPID), which is
the privacy critical identifier.  The PCE verifies the report
generated by the PVE and rejects the request to generate the PPID if
the report was generated by an enclave that was not initialized with
the PROVISION bit set, see line 109 of psw/ae/pce/pce.cpp.

The PCE enclave then recomputes the message hash using the PEK that it
is provided and verifies that the value matches the value in the data
field of the attestation report from the PVE enclave.  If the values
do not match the PPID generation request is denied.  The PCE enclave
then encrypts the PPID with the PEK key and the encrypted PPID is
returned to Intel to use as the platform identifier.

The PPID is the CMAC over a 16 byte null message which uses a derived
provisioning key based on CPUSVN and ISVSVN values set to zero.  See
the get_ppid() function in psw/ae/pce/pce_helper.cpp.

I believe this effectively denies the ability of anyone other then
Intel, who holds the private portion of the ECC256 signature key used
to authenticate the PEK, from using the PCE enclave to generate a
platform identifier.

As I conceded above, there could be an academic deficiency in all
this, I'm not qualified to comment.  I believe there is a reasonably
solid functional guarantee that on a locked platform the process
cannot be easily subverted by a privacy aggressor.

We contend that the model we propose below can also deliver this
guarantee as long as ring 0 privileges are not compromised by an
aggressor, which is the best that an FLC platform can do.

Once again, the important design factor in all of this is the premise
that the launch enclave will not allow enclaves other then the PCE and
PVE to access the PROVISION bit.  Hence my comments about SGX being
about establishing islands of trust and the negotiation of security
contexts between those islands of trust.

> No, I have no clue why Intel did it this way.  I consider it to be a
> mistake.

Are you referring to there being a mistake in the trust relationships
that the provisioning protocol implements or the overall concept of a
provisioning key?

We've got over two man years into re-implementing all of this.  The
Intel code is a bit challenging to follow and not well documented, it
is now.... :-), but we have developed a great deal of respect for how
good the individuals behind the design of this were.

> >> The launch enclave is critical to that guarantee.
> >> 
> >> It is completely understandable why a locked down, (non-FLC) hardware
> >> platform, is undesirable in this community.  That doesn't mean that a
> >> launch enclave as a concept is unneeded or necessarily evil.
> >> 
> >> In an FLC environment the kernel assumes responsibility for SGX
> >> privacy and security.  This means that we need to do at least as well
> >> with a kernel based model as to what is currently available.
> >> 
> >>> There are other ways to accomplish it that might be better in some
> >>> respects.  For example, there could be /dev/sgx and
> >>> /dev/sgx_rights/provision.  The former exposes the whole sgx API,
> >>> except that it doesn???t allow provisioning by default. The latter
> >>> does nothing by itself. To run a provisioning enclave, you open both
> >>> nodes, then do something like:
> >>> 
> >>> ioctl(sgx, SGX_IOC_ADD_RIGHT, sgx_provisioning);
> >>> 
> >>> This requires extra syscalls, but it doesn't have the combinatorial
> >>> explosion problem.
> >> 
> >> Here is a proposal for the driver to add the needed policy control
> >> that is 'SGXy' in nature.  The 'SGXy' way is to use MRSIGNER values as
> >> the currency for security policy management.
> >> 
> >> The driver should establish the equivalent of three linked lists,
> >> maintainable via /sysfs pseudo-files or equivalent plumbing.  The
> >> lists are referenced by the kernel to enforce the following policies.
> >> 
> >> 1.) The right to initialize an enclave without special attributes.
> >> 
> >> 2.) The right to initialize an enclave with the PROVISION_KEY attribute set.
> >> 
> >> 3.) The right to initialize an enclave with the LICENSE_KEY attribute set.
> >> 
> >> The lists are populated with MRSIGNER values of enclaves that are
> >> allowed to initialize under the specified conditions.

> NAK because this is insufficient.  You're thinking of a model in
> which SGX-like protection is all that's needed.  This is an
> inadequate model of the real world.  The attack I'm most concerned
> about wrt provisioning is an attack in which an unauthorized user is
> permitted.

We will be interested in your comments as to why the proposal is
insufficient in the real world of FLC.

I believe the proposed architecture can be defended as being effective
in the real world, as it allows the root user to use cryptographic
protections of access to the PROVISION bit and to enclave execution in
general.  On FLC that is the strongest guarantee that can be
delivered.

When we speak of 'unauthorized' users I believe we are speaking in the
parlance of discretionary access controls which has a much wider TCB
scope then the cryptographic model we are proposing.  The model we
propose allows the platform owner (root) to effectively implement the
same level of security over the PROVISION bit that current locked
platforms have, in a free and open fashion of course.

We can certainly attempt to explain our position further.

> The use case I see for attestation *privacy*

Things seemed to end here so I assume that is where your e-mail went
awry.

I hope the clarifications provided above will assist further
discussion.

Have a good day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"When I am working on a problem I never think about beauty.  I only
 think about how to solve the problem.  But when I have finished, if
 the solution is not beautiful, I know it is wrong."
                                -- Buckminster Fuller
