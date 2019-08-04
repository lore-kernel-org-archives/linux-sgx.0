Return-Path: <SRS0=xPMG=WA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CAAC19759
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Aug 2019 22:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEAE520882
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Aug 2019 22:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564957239;
	bh=4+uDKxvqM9OIkq0s1X/uCEDzLdtlyFxWBL44sjlJLNY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=r9CrGegI+g7Y1d8kHv2EPWjUqZyo2x8dSHgmeRlcPkk9VKfVlb4wTahM3v3KlwIUV
	 a/WQFrtCCVu/tTPscLSTB3ehjSKlqUzlH+9+5cjEmfUcTUrbw4Ie9ctFfoZEqoc7w7
	 2aimMpWqcAFBhNegfpc74wKgPFzBwgA01yFZ/Qkg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfHDWUj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Aug 2019 18:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbfHDWUj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Aug 2019 18:20:39 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8E3217F4
        for <linux-sgx@vger.kernel.org>; Sun,  4 Aug 2019 22:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564957237;
        bh=4+uDKxvqM9OIkq0s1X/uCEDzLdtlyFxWBL44sjlJLNY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Tiia823kYS4VDzjd3QxvKVRALE/EH8rPqaqkmTqlmNOoAD4i6yTKF0V4z2qSE7POp
         O/1WaTfPduF1J9dqqYXGfA7Eu9OWFwaRwDyFYkaUAP2k6FNXzF/+TikFXkV5InohzH
         hRbanB6qfPyAdE9NCgYLBJLxtoSdb9msGaf6saM0=
Received: by mail-wm1-f43.google.com with SMTP id 207so72944101wma.1
        for <linux-sgx@vger.kernel.org>; Sun, 04 Aug 2019 15:20:37 -0700 (PDT)
X-Gm-Message-State: APjAAAUqeRHMkhjH/4ij11El1AaxMLAlJjfmAmXSiVwEiSskat9b8ER4
        6zT0qPPXVTVm6vwSVKVug0vtg3vhpJIPxMp7ydrbQw==
X-Google-Smtp-Source: APXvYqypYUCkDQdokcmAHSDQYXibQ3M2IW5YYjvxRskvGd32mMTS3XclDKNYo+ABvlfFbHHa0Y348qCjKX1x2AaSd3c=
X-Received: by 2002:a1c:a942:: with SMTP id s63mr14669087wme.76.1564957236010;
 Sun, 04 Aug 2019 15:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190617222438.2080-5-sean.j.christopherson@intel.com>
 <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
 <20190619152018.GC1203@linux.intel.com> <20190620221702.GE20474@linux.intel.com>
 <20190707190809.GE19593@linux.intel.com> <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
 <20190708161932.GE20433@linux.intel.com> <20190709160634.3yupyabf5svnj4ds@linux.intel.com>
 <20190710172553.GE4348@linux.intel.com> <CALCETrXMAwHod_KZYPGWjTjg-fxOb1=02=Qj2g1o624wOPfPZQ@mail.gmail.com>
 <20190801163839.wvcnq57hity4wwrk@linux.intel.com>
In-Reply-To: <20190801163839.wvcnq57hity4wwrk@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 4 Aug 2019 15:20:24 -0700
X-Gmail-Original-Message-ID: <CALCETrWBewZyqVUf3cPDj11eSWXqfDG0z50vVw+Yg0Z8r0AtCg@mail.gmail.com>
Message-ID: <CALCETrWBewZyqVUf3cPDj11eSWXqfDG0z50vVw+Yg0Z8r0AtCg@mail.gmail.com>
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

On Thu, Aug 1, 2019 at 9:38 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Jul 15, 2019 at 03:29:23PM -0700, Andy Lutomirski wrote:
> > I would say it differently: regardless of exactly how /dev/sgx/enclave
> > is wired up under the hood, we want a way that a process can be
> > granted permission to usefully run enclaves without being granted
> > permission to execute whatever bytes of code it wants.  Preferably
> > without requiring LSMs to maintain some form of enclave signature
> > whitelist.
>
> Would it be better to have a signer whitelist instead or some
> combination? E.g. you could whiteliste either by signer or
> enclave signature.
>

I'm not sure, and also don't really think we need to commit to an
answer right now.  I do think that the eventual solution should be
more flexible than just whitelisting the signers.  In particular, it
should be possible to make secure enclaves, open-source or otherwise,
that are reproducibly buildable.  This more or less requires that the
signing private key not be a secret, which means that no one would
want to whitelist the signing key.  The enclave would be trusted, and
would seal data, on the basis of its MRENCLAVE, and the policy, if
any, would want to whitelist the MRENCLAVE or perhaps the whole
SIGSTRUCT.

But my overall point is that it should be possible to have a conherent
policy that allows any enclave whatsoever to run but that still
respects EXECMEM and such.
