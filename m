Return-Path: <SRS0=uhim=EC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED917C388F9
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 10:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB30E22281
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Oct 2020 10:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898618AbgJ0Kj6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Oct 2020 06:39:58 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58558 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898508AbgJ0KjU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Oct 2020 06:39:20 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 09RAcf2K012871;
        Tue, 27 Oct 2020 05:38:41 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 09RAce9n012870;
        Tue, 27 Oct 2020 05:38:40 -0500
Date:   Tue, 27 Oct 2020 05:38:40 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com,
        Mikko Ylinen <mikko.ylinen@intel.com>
Subject: Re: [PATCH v39 15/24] x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
Message-ID: <20201027103840.GA12095@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com> <20201003045059.665934-16-jarkko.sakkinen@linux.intel.com> <7bb4ff7b-0778-ad70-1fe0-6e1db284d45a@intel.com> <20201023101736.GG168477@linux.intel.com> <f2ff64e6-8fe1-55ee-ae7c-f19d7907d60e@intel.com> <20201024113403.GA29427@kernel.org> <CALCETrWxA6AgU8zg=npS=4NaA1_Pu9UwScEnr_Gk0wF-BOmqqQ@mail.gmail.com> <20201024194632.GA3642@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201024194632.GA3642@kernel.org>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 27 Oct 2020 05:38:41 -0500 (CDT)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 24, 2020 at 11:23:11PM +0300, Jarkko Sakkinen wrote:

Good morning, I hope the day is starting well for everyone.

> On Sat, Oct 24, 2020 at 08:47:28AM -0700, Andy Lutomirski wrote:
> > On Sat, Oct 24, 2020 at 4:34 AM Jarkko Sakkinen <kernel.org@kernel.org> wrote:
> > >
> > > On Fri, Oct 23, 2020 at 07:19:05AM -0700, Dave Hansen wrote:
> > > > On 10/23/20 3:17 AM, Jarkko Sakkinen wrote:
> > > > > On Tue, Oct 20, 2020 at 02:19:26PM -0700, Dave Hansen wrote:
> > > > >> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
> > > > >>> + * Failure to explicitly request access to a restricted attribute will cause
> > > > >>> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> > > > >>> + * is access to the PROVISION_KEY.
> > > > >> Could we also justify why access is restricted, please?  Maybe:
> > > > >>
> > > > >>    Access is restricted because PROVISION_KEY is burned uniquely
> > > > >>    into each each processor, making it a perfect unique identifier
> > > > >>    with privacy and fingerprinting implications.
> > > > >>
> > > > >> Are there any other reasons for doing it this way?
> > > > > AFAIK, if I interperet the SDM correctl, PROVISION_KEY and
> > > > > PROVISION_SEALING_KEY also have random salt added, i.e. they change
> > > > > every boot cycle.
> > > > >
> > > > > There is "RAND = yes" on those keys in Table 40-64 of Intel SDM volume
> > > > > 3D :-)
> > > >
> > > > Does that mean there are no privacy implications from access to the
> > > > provisioning keys?  If that's true, why do we need a separate permission
> > > > framework for creating provisioning enclaves?
> > >
> > > As I've understood it, the key material for those keys is not even
> > > required in the current SGX architecture, it was used in the legacy EPID
> > > scheme, but the attribute itself is useful.
> > >
> > > Let's assume that we have some sort of quoting enclave Q, which guards a
> > > public key pair, which signs quotes of other enclaves. Let's assume we
> > > have an attestation server A, which will enable some capabilities [*],
> > > if it receives a quote signed with that public key pair.
> > >
> > > 1. E gets the report key with EGETKEY.
> > > 2. E constructs REPORTDATA (37.16) and TARGETINFO (37.17) structures.
> > >    The former describes the enclaves contents and attributes and latter
> > >    the target, i.e. Q in this artitificial example.
> > > 3. E calls EREPORT to generate a structure called REPORT MAC'd with the
> > >    *targets* report key. It knows, which key to usue from REPORTDATA.
> > > 4. The runtime will then pass this to Q.
> > > 5. Q will check if ATTRIBUTE.PROVISION_KEY is set. If it is, Q will
> > >    know that the enclave is allowed to get attested. Then it will
> > >    sign the report with the guarded public key pair and send it to
> > >    the attestation server.
> > 
> > I think you have this a little bit off.  AIUI E won't have
> > ATTRIBUTE.PROVISION_KEY set -- Q will.  Q uses the provisioning key to
> > convince an Intel server that it's running on a genuine Intel CPU, and
> > the Intel server will return a signed certificate that Q can chain off
> > of to generate attestations for E.

> Right, I was confused by that RAND column, until Jethro corrected me.

The RAND column is probably misnamed, it doesn't really imply random
in the common sense of the meaning.  It implies that a 256 bit nonce
(keyid) can be supplied to the ENCLU[EGETKEY] instruction to perturb
the key derivation process.

The value is actually available in plaintext form as part of the
metadata for sealed data.

If it was really a random value, attestation wouldn't work.

> Actually, quoting enclave (QE) authorizes itself with a provisioning
> certification enclave (PCE), which holds certificates and revocation
> lists for provisioning secrets unique to a CPU. And the sequence that I
> described happens between PCE and QE. It accepts requests from enclaves
> with ATTRIBUTES.PROVISION key bits set to 1 according to:
> 
>   https://software.intel.com/content/dam/develop/external/us/en/documents/intel-sgx-support-for-third-party-attestation-801017.pdf
> 
> The source code for the reference  is available here:
> 
>   https://github.com/intel/SGXDataCenterAttestationPrimitives
> 
> And binaries are here:
> 
>   https://01.org/intel-softwareguard-extensions/downloads/intel-sgx-dcap-1.6-release
>
> They are provided for the inevitable reason that, it is the way bind
> to the hardware, i.e. proof that you are running on a genuine CPU.
>
> The network part is that PCE and QE can certify to an application,
> if an enclave running in a different computer is an enclave.

All of this discussion has lacked a certain amount of precision, as a
result the original issue with respect to Dave's concern regarding the
privacy implications of an enclave posessing the PROVISION_KEY
attribute has been lost.

First of all, it is important to note that two types of attestation
are available, EPID and DCAP/ECDSA.  They differ in their
implementation with respect to which enclaves need to have access to
derivation of the PROVISION_KEY.  What does remain constant is the
role that the PROVISION_KEY plays in all this.

The Platform Certification Enclave (PCE) has two roles:

1.) Generate a Platform Provisioning IDentifier (PPID).

2.) Certification of the fact that an enclave, other then the PCE, is
running on the same platform at a particular Trusted Computing Base
(TCB) level.

Being able to generate a PPID is the most privacy sensitive operation
that an enclave can peform, hence the recommendation to restrict
access to the attribute bit that allows an enclave to create a
derivation of the root provisioning key.

The PPID is a 256 bit symmetric key that is generated with the keyid
and security version values all set to null values.  As a result, any
enclave with a given MRSIGNER value will generate the same key value.
That value is used by Intel, and potentially others, to uniquely
identify the platform as long as it exists.

The PPID can be admixed with other information, such as the platform
security version of an enclave, to create a unique identifier for the
TCB state of enclave based software running on a particular platform.
This is role 2 of the PCE that I noted above.

In DCAP attestation, which is what Jarkko is referring to, both the
Quoting Enclave (QE) and PCE have access to PROVISION_KEY derivation.

In EPID attestation the PCE and the Provisioning Enclave (PVE) have
access to PROVISION_KEY derivation.

I guess it is up to community consensus as to whether or not this is a
privacy/security sensitive issue.  It provides precise enough
identification that Intel uses it to determine whether or not a
platform should be allowed or denied the ability to participate in
EPID attestation.

I believe that this is being used to to force the cloud based
platforms to use DCAP rather then EPID based attestation.  The
provision keys for these SKU's are not included in the Intel
Attestation Service (IAS) database so they cannot identify themselves
for provisioning of an EPID private key.

Since Intel has access to the root provisioning keys it can identify a
platform a-priori.  Other entities can use this infrastructure for
uniquely identifying platforms but it has to be done via an enrollment
process for a given signing key.

> /Jarkko

Hopefully the above clarifications are helpful.

Have a good day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I suppose that could could happen but he wouldn't know a Galois Field
 if it kicked him in the nuts."
                                -- Anonymous mathematician
                                   Resurrection.
