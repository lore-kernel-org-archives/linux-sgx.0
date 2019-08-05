Return-Path: <SRS0=oZh+=WB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792EBC0650F
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Aug 2019 21:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF9D216F4
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Aug 2019 21:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565040637;
	bh=bU2EdjyrlVSqPSDwqxFhx3rVMAseexUwlZ36ObsJD5I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zwQXYz3rN11vTgm9h1b7cMnuwKrpRkwX/aDXhW3uVtB0F9Wp4f+zcHO3UG4RrBsmz
	 7JY2e1sK7QEOKwzK1nVP2egzX38daUmOIkkvDUy29MEuFquwLLb/BxCUZcDB3P2Ggz
	 AG5Ov1FASDHJvNJuOOqeTOboeQh5SJue8xujNJOc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHEVah (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Aug 2019 17:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbfHEVag (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Aug 2019 17:30:36 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4576C2173C
        for <linux-sgx@vger.kernel.org>; Mon,  5 Aug 2019 21:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040635;
        bh=bU2EdjyrlVSqPSDwqxFhx3rVMAseexUwlZ36ObsJD5I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=skDhAqQtLhK6T9wZtuaemo1o5e5E84OuKPLPr/mSYDktc+mRy5UTMvGM9ClBf58zs
         WPOMRxDiQVMpzR3zO9NfpCGkhBYbLNu8FR91nOEtWwz34hCnAlt7/tFA048QH/bqwB
         lvXnKQKoefaX/tmkdLYD7ob7N++dKfyu7A24ucpA=
Received: by mail-wm1-f41.google.com with SMTP id g67so70268760wme.1
        for <linux-sgx@vger.kernel.org>; Mon, 05 Aug 2019 14:30:35 -0700 (PDT)
X-Gm-Message-State: APjAAAUNRv8SeR6OgJz3+DPZoMkNNVfEeLcvMaBFtb2J7Glkf/IabXOO
        9h9jlZW6jEUYkpGsps3RAJYpxERhh7U/k70z/2Cy4Q==
X-Google-Smtp-Source: APXvYqxXkE3NHpwDZvfzWnYwkmLM3SlFEulCiSUglpZtaxjMLweZ+bmDk9MERg5aPe9ADDw7RinGpjv9/NN5waY6SZ8=
X-Received: by 2002:a7b:c149:: with SMTP id z9mr306648wmi.0.1565040633709;
 Mon, 05 Aug 2019 14:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190619152018.GC1203@linux.intel.com> <20190620221702.GE20474@linux.intel.com>
 <20190707190809.GE19593@linux.intel.com> <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
 <20190708161932.GE20433@linux.intel.com> <20190709160634.3yupyabf5svnj4ds@linux.intel.com>
 <20190710172553.GE4348@linux.intel.com> <CALCETrXMAwHod_KZYPGWjTjg-fxOb1=02=Qj2g1o624wOPfPZQ@mail.gmail.com>
 <20190801163839.wvcnq57hity4wwrk@linux.intel.com> <CALCETrWBewZyqVUf3cPDj11eSWXqfDG0z50vVw+Yg0Z8r0AtCg@mail.gmail.com>
 <20190805205104.6ylxomqq37deqb3v@linux.intel.com>
In-Reply-To: <20190805205104.6ylxomqq37deqb3v@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 5 Aug 2019 14:30:22 -0700
X-Gmail-Original-Message-ID: <CALCETrVcaL5KfR0V2fiHzQtyQdEC7d9iFNDKp9yBj7QZQsdXyw@mail.gmail.com>
Message-ID: <CALCETrVcaL5KfR0V2fiHzQtyQdEC7d9iFNDKp9yBj7QZQsdXyw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define enclave
 pages' protection bits
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 5, 2019 at 1:51 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Sun, Aug 04, 2019 at 03:20:24PM -0700, Andy Lutomirski wrote:
> > On Thu, Aug 1, 2019 at 9:38 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Mon, Jul 15, 2019 at 03:29:23PM -0700, Andy Lutomirski wrote:
> > > > I would say it differently: regardless of exactly how /dev/sgx/enclave
> > > > is wired up under the hood, we want a way that a process can be
> > > > granted permission to usefully run enclaves without being granted
> > > > permission to execute whatever bytes of code it wants.  Preferably
> > > > without requiring LSMs to maintain some form of enclave signature
> > > > whitelist.
> > >
> > > Would it be better to have a signer whitelist instead or some
> > > combination? E.g. you could whiteliste either by signer or
> > > enclave signature.
> > >
> >
> > I'm not sure, and also don't really think we need to commit to an
> > answer right now.  I do think that the eventual solution should be
> > more flexible than just whitelisting the signers.  In particular, it
> > should be possible to make secure enclaves, open-source or otherwise,
> > that are reproducibly buildable.  This more or less requires that the
> > signing private key not be a secret, which means that no one would
> > want to whitelist the signing key.  The enclave would be trusted, and
> > would seal data, on the basis of its MRENCLAVE, and the policy, if
> > any, would want to whitelist the MRENCLAVE or perhaps the whole
> > SIGSTRUCT.
> >
> > But my overall point is that it should be possible to have a conherent
> > policy that allows any enclave whatsoever to run but that still
> > respects EXECMEM and such.
>
> So could kernel embed a fixed signing key that would be made available
> through sysfs for signing? Already have one for my selftest.
>

Do you mean a public and private key?  I was imagining that someone
would just create a key pair and publish it for the case of SGX
programs that don't depend on MRSIGNER.  There doesn't have to be just
one.

But I may be misunderstanding you.
