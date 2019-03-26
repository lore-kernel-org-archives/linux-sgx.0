Return-Path: <SRS0=OPzR=R5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCF3C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 17:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F76420879
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Mar 2019 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553620127;
	bh=fnmB69yMKqMc+7KaVc4Qf/jiOL8ofWqwpwaUEsDlxdM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=g+o78/Xb/6cM0vQS02wH+iPHciFFbnQkNV0dYEa58W3M9s0aSk8iZhv+bmjzjyr6b
	 /F2xpUyCPWJebeVE3CxHGhy3W/W+B0XH230gn+UxaHh/kUhA+H1VvuNVPwkV9dAwxi
	 SfS1O9v2QkyNHVj6YM6fR7WLMEKY8/ReAab7WlKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfCZRIq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbfCZRIq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 26 Mar 2019 13:08:46 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9DD52087E
        for <linux-sgx@vger.kernel.org>; Tue, 26 Mar 2019 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553620125;
        bh=fnmB69yMKqMc+7KaVc4Qf/jiOL8ofWqwpwaUEsDlxdM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1z793o6kBznOuMvG1VODLsDenbvcNxaMmPpkkwB1Tj3T7YlGV8T30Hq0TK1+Bvfyr
         IKOqiMuj8qqmdyNrt2wRX2WCG3QNJinTIk3G+Ewij3Kh6xDYJzLsX0y+pVjIgXeoN2
         /g+eZNCZh7jLZ1sr46YHSBpDeVejnxZ87Q428V3c=
Received: by mail-wr1-f47.google.com with SMTP id j9so15275234wrn.6
        for <linux-sgx@vger.kernel.org>; Tue, 26 Mar 2019 10:08:44 -0700 (PDT)
X-Gm-Message-State: APjAAAU7ehaMBx1otTZ6dykyJuNjQ4q+n7IjqNSkPRKLj613nKtm1zHJ
        wz8lGxT619FWz5FtrrZVvkNpNcstYf7YJ5y9vDIRqQ==
X-Google-Smtp-Source: APXvYqyxXYGuwahuAtAyhTFxlqdZV6pUNGRT1aSSvoJKCza3lzXzyFlU/v7AmAkAeoiKaf97tFc0BQVkGuUWDFnLyC0=
X-Received: by 2002:adf:f011:: with SMTP id j17mr18108124wro.330.1553620123457;
 Tue, 26 Mar 2019 10:08:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
 <20190320162119.4469-25-jarkko.sakkinen@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C484@ORSMSX116.amr.corp.intel.com>
 <20190320191318.GF30469@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85C5AB@ORSMSX116.amr.corp.intel.com>
 <20190322215903.GE12666@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F4E85E481@ORSMSX116.amr.corp.intel.com>
 <CALCETrV589POrG3RaPHBWOFuytkWjeJgJgLHk4OKbizOgJVKZQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85E989@ORSMSX116.amr.corp.intel.com>
 <20190325180349.GF31069@linux.intel.com> <CALCETrXqb3CHefN-RLudC61jwdbLFS8cXuS4V5OJ6HTuf_arYw@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E85FABF@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 26 Mar 2019 10:08:31 -0700
X-Gmail-Original-Message-ID: <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com>
Message-ID: <CALCETrVcR_etAHSVZxvCz7CcPnF4ajpcWiRCtFrOckVWVJByHA@mail.gmail.com>
Subject: Re: [PATCH v19,RESEND 24/27] x86/vdso: Add __vdso_sgx_enter_enclave()
 to wrap SGX enclave transitions
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 25, 2019 at 9:53 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > On Mon, Mar 25, 2019 at 11:03 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Sun, Mar 24, 2019 at 01:59:48AM -0700, Xing, Cedric wrote:
> > > > As said in my previous email, this vDSO API isn't even compliant to
> > > > x86_64 ABI and is absolutely NOT for average developers. Instead,
> > > > host/enclave communications are expected to be handled by SDKs and
> > > > those developers will be very aware of the limitations of their
> > > > targeted environments, and will need the freedom to deploy optimal
> > solutions.
> >
> > > I fully realize that the above approach saddles Cedric and the SDK
> > > team with the extra task of justifying the need for two vDSO
> > > interfaces, and likely reduces the probability of their proposal bein=
g
> > > accepted.  But, we don't *force* the SDK to be rewritten, and we gain
> > > a vDSO interface that many people want and is acceptable to the
> > > maintainers (unless I've horribly misread Andy's position).
> >
> > I don't think you've horribly misread it.  I would like to keep the
> > stuff in the vDSO as minimal as possible.  If we need to add a fancier
> > interface down the line, then that's fine.
>
> Andy, I don't know "many people" is how many in Sean's email. I couldn't =
tell you how long it took us to settle on the current SGX ISA because you w=
ould just LAUGH! Why? Because it took insanely ridiculously long. Why that =
long? Because the h/w and u-code teams would like to trim down the ISA as m=
uch as possible. The fact is, whatever new is released, Intel will have to =
maintain it on all future processors FOREVER! That means significant/on-goi=
ng cost to Intel. So any addition to ISA has to undergo extensive reviews t=
hat involve all kinds of experts from both within Intel and externally, and=
 would usually take years, before you can see what you are seeing today. As=
 I said in my earlier emails, RBP is NOT needed for interrupt/exception han=
dlers, then how did RBP end up being restored at AEX? You can guess how man=
y people were standing behind it! Sean has no clue! I can assure you!
>
> Guess we've talked enough on the technical front. So let's talk about it =
on the business front. Let me take a step back. Let's say you are right, al=
l enclaves would eventually be coded in the way you want. We (Intel SDK tea=
m) were convinced to follow your approach. But there were existing enclaves=
 and a migration path would be needed. Would you like to support us? It'd b=
e only 9 LOC on your side but how much would incur on our side? If you beli=
eve you are doing right thing, then acceptance is the next thing you should=
 think of. You should offer an easy path for those who did "wrong" to get o=
n your "right" boat. Don't you think so?
>

I suppose the real question is: are there a significant number of
users who will want to run enclaves created using an old SDK on Linux?
 And will there actually be support for doing this in the software
stack?

If the answer to both questions is yes, then it seems like it could be
reasonable to support it in the vDSO.  But I still think it should
probably be a different vDSO entry point so that the normal case
doesn't become more complicated.
