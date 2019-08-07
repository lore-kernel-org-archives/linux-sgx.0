Return-Path: <SRS0=l2ne=WD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AC2C433FF
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 18:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00CBD21EF2
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 18:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389399AbfHGSvs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 14:51:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:16496 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389245AbfHGSvs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 14:51:48 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 11:51:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="182367665"
Received: from geyerral-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.199])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Aug 2019 11:51:43 -0700
Date:   Wed, 7 Aug 2019 21:51:43 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190807185143.2mfslzsa22fw74qf@linux.intel.com>
References: <20190707190809.GE19593@linux.intel.com>
 <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
 <20190708161932.GE20433@linux.intel.com>
 <20190709160634.3yupyabf5svnj4ds@linux.intel.com>
 <20190710172553.GE4348@linux.intel.com>
 <CALCETrXMAwHod_KZYPGWjTjg-fxOb1=02=Qj2g1o624wOPfPZQ@mail.gmail.com>
 <20190801163839.wvcnq57hity4wwrk@linux.intel.com>
 <CALCETrWBewZyqVUf3cPDj11eSWXqfDG0z50vVw+Yg0Z8r0AtCg@mail.gmail.com>
 <20190805205104.6ylxomqq37deqb3v@linux.intel.com>
 <CALCETrVcaL5KfR0V2fiHzQtyQdEC7d9iFNDKp9yBj7QZQsdXyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVcaL5KfR0V2fiHzQtyQdEC7d9iFNDKp9yBj7QZQsdXyw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 05, 2019 at 02:30:22PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 5, 2019 at 1:51 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Sun, Aug 04, 2019 at 03:20:24PM -0700, Andy Lutomirski wrote:
> > > On Thu, Aug 1, 2019 at 9:38 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > >
> > > > On Mon, Jul 15, 2019 at 03:29:23PM -0700, Andy Lutomirski wrote:
> > > > > I would say it differently: regardless of exactly how /dev/sgx/enclave
> > > > > is wired up under the hood, we want a way that a process can be
> > > > > granted permission to usefully run enclaves without being granted
> > > > > permission to execute whatever bytes of code it wants.  Preferably
> > > > > without requiring LSMs to maintain some form of enclave signature
> > > > > whitelist.
> > > >
> > > > Would it be better to have a signer whitelist instead or some
> > > > combination? E.g. you could whiteliste either by signer or
> > > > enclave signature.
> > > >
> > >
> > > I'm not sure, and also don't really think we need to commit to an
> > > answer right now.  I do think that the eventual solution should be
> > > more flexible than just whitelisting the signers.  In particular, it
> > > should be possible to make secure enclaves, open-source or otherwise,
> > > that are reproducibly buildable.  This more or less requires that the
> > > signing private key not be a secret, which means that no one would
> > > want to whitelist the signing key.  The enclave would be trusted, and
> > > would seal data, on the basis of its MRENCLAVE, and the policy, if
> > > any, would want to whitelist the MRENCLAVE or perhaps the whole
> > > SIGSTRUCT.
> > >
> > > But my overall point is that it should be possible to have a conherent
> > > policy that allows any enclave whatsoever to run but that still
> > > respects EXECMEM and such.
> >
> > So could kernel embed a fixed signing key that would be made available
> > through sysfs for signing? Already have one for my selftest.
> >
> 
> Do you mean a public and private key?  I was imagining that someone
> would just create a key pair and publish it for the case of SGX
> programs that don't depend on MRSIGNER.  There doesn't have to be just
> one.
> 
> But I may be misunderstanding you.

Aa, OK, got you. I actually misunderstood you.

/Jarkko
