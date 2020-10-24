Return-Path: <SRS0=IGRU=D7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70C5C4363A
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Oct 2020 20:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73340222BA
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Oct 2020 20:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603570995;
	bh=OUUHQchNeaZSA5Ychtwc5x6Ol2ZEQdBNnz0+GXVGGS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZiinUW0twAkU3Ey3DzMpVjQBJ8rW//7LndEjSoRztWB/hm8UHcasbGJK1l5eYZZeH
	 SB5jhno21QmsuMb9iAXZaS6UVNH+27onS7SyA2RhX236gglXm7kldlH50tEraAQ9AK
	 tXWM2PXfxUM+zsLNQJeZ5Vj/tD04WSH3wd9MUc7I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764371AbgJXUXP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764296AbgJXUXO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 24 Oct 2020 16:23:14 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B73A22276;
        Sat, 24 Oct 2020 20:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603570993;
        bh=OUUHQchNeaZSA5Ychtwc5x6Ol2ZEQdBNnz0+GXVGGS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dBz//X92mG9QZRUy9A35CcTIz07Nwas4kA/0nBtU44U/fd57I9Nz9z4IKa9DauvXd
         9QwlqNsQ+bAsl29Yz18wrX3M26yL/BtOrXbiT9krW6WYt8LZkYdK9FqpUAgbBlDLyo
         a5ScUowMy9DKq7jv52hfWgTj3ZY7TSIJnkOCaxVk=
Date:   Sat, 24 Oct 2020 23:23:11 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20201024194632.GA3642@kernel.org>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-16-jarkko.sakkinen@linux.intel.com>
 <7bb4ff7b-0778-ad70-1fe0-6e1db284d45a@intel.com>
 <20201023101736.GG168477@linux.intel.com>
 <f2ff64e6-8fe1-55ee-ae7c-f19d7907d60e@intel.com>
 <20201024113403.GA29427@kernel.org>
 <CALCETrWxA6AgU8zg=npS=4NaA1_Pu9UwScEnr_Gk0wF-BOmqqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWxA6AgU8zg=npS=4NaA1_Pu9UwScEnr_Gk0wF-BOmqqQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 24, 2020 at 08:47:28AM -0700, Andy Lutomirski wrote:
> On Sat, Oct 24, 2020 at 4:34 AM Jarkko Sakkinen <kernel.org@kernel.org> wrote:
> >
> > On Fri, Oct 23, 2020 at 07:19:05AM -0700, Dave Hansen wrote:
> > > On 10/23/20 3:17 AM, Jarkko Sakkinen wrote:
> > > > On Tue, Oct 20, 2020 at 02:19:26PM -0700, Dave Hansen wrote:
> > > >> On 10/2/20 9:50 PM, Jarkko Sakkinen wrote:
> > > >>> + * Failure to explicitly request access to a restricted attribute will cause
> > > >>> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> > > >>> + * is access to the PROVISION_KEY.
> > > >> Could we also justify why access is restricted, please?  Maybe:
> > > >>
> > > >>    Access is restricted because PROVISION_KEY is burned uniquely
> > > >>    into each each processor, making it a perfect unique identifier
> > > >>    with privacy and fingerprinting implications.
> > > >>
> > > >> Are there any other reasons for doing it this way?
> > > > AFAIK, if I interperet the SDM correctl, PROVISION_KEY and
> > > > PROVISION_SEALING_KEY also have random salt added, i.e. they change
> > > > every boot cycle.
> > > >
> > > > There is "RAND = yes" on those keys in Table 40-64 of Intel SDM volume
> > > > 3D :-)
> > >
> > > Does that mean there are no privacy implications from access to the
> > > provisioning keys?  If that's true, why do we need a separate permission
> > > framework for creating provisioning enclaves?
> >
> > As I've understood it, the key material for those keys is not even
> > required in the current SGX architecture, it was used in the legacy EPID
> > scheme, but the attribute itself is useful.
> >
> > Let's assume that we have some sort of quoting enclave Q, which guards a
> > public key pair, which signs quotes of other enclaves. Let's assume we
> > have an attestation server A, which will enable some capabilities [*],
> > if it receives a quote signed with that public key pair.
> >
> > 1. E gets the report key with EGETKEY.
> > 2. E constructs REPORTDATA (37.16) and TARGETINFO (37.17) structures.
> >    The former describes the enclaves contents and attributes and latter
> >    the target, i.e. Q in this artitificial example.
> > 3. E calls EREPORT to generate a structure called REPORT MAC'd with the
> >    *targets* report key. It knows, which key to usue from REPORTDATA.
> > 4. The runtime will then pass this to Q.
> > 5. Q will check if ATTRIBUTE.PROVISION_KEY is set. If it is, Q will
> >    know that the enclave is allowed to get attested. Then it will
> >    sign the report with the guarded public key pair and send it to
> >    the attestation server.
> 
> I think you have this a little bit off.  AIUI E won't have
> ATTRIBUTE.PROVISION_KEY set -- Q will.  Q uses the provisioning key to
> convince an Intel server that it's running on a genuine Intel CPU, and
> the Intel server will return a signed certificate that Q can chain off
> of to generate attestations for E.

Right, I was confused by that RAND column, until Jethro corrected me.

Actually, quoting enclave (QE) authorizes itself with a provisioning
certification enclave (PCE), which holds certificates and revocation
lists for provisioning secrets unique to a CPU. And the sequence that I
described happens between PCE and QE. It accepts requests from enclaves
with ATTRIBUTES.PROVISION key bits set to 1 according to:

  https://software.intel.com/content/dam/develop/external/us/en/documents/intel-sgx-support-for-third-party-attestation-801017.pdf

The source code for the reference  is available here:

  https://github.com/intel/SGXDataCenterAttestationPrimitives

And binaries are here:

  https://01.org/intel-softwareguard-extensions/downloads/intel-sgx-dcap-1.6-release

They are provided for the inevitable reason that, it is the way bind to
the hardware, i.e. proof that you are running on a genuine CPU.

The network part is that PCE and QE can certify to an application, if an
enclave running in a different computer is an enclave.

> Dave, I would rephrase what you're saying a bit.  The PROVISION_KEY
> attribute allows enclaves to access keys that are unique to a
> processor and unchangeable.  Unlike other SGX keys, these keys are not
> affected by OWNER_EPOCH changes and therefore cannot be reset.

/Jarkko
