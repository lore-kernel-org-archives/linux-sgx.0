Return-Path: <SRS0=lIZr=OU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE5EC6783B
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 23:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F47E20851
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Dec 2018 23:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544569868;
	bh=QfNb33dE6va6caV5f1TR23O3lZh+zahl+vG3UOH7V9s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Ko7QsLjuM1a4M2gsQNQ9quX78/xg5alQ1hyMP0YW/BKXXsJ5gWuprCL/pFB2eA7Gf
	 6IrohNw3NfNuzK/rFL5yXU7n9rYWHLFFthvcUpJluhwPdiFtonunfvkgm4tn/XC8G/
	 DgsU6soaswXuFpPEh2qCnZU/JxqJ2p6oaEBWi6pY=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F47E20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbeLKXLH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 18:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbeLKXLH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 18:11:07 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 480A821473
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 23:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544569866;
        bh=QfNb33dE6va6caV5f1TR23O3lZh+zahl+vG3UOH7V9s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=g/ia8ae+wO15vu/vn7fvujUhArEszq5r/E91roSHC2z/Joyi/JN+p0YxCHV9R4nvt
         d4DRc9mkl4Xf80Xt582JC8gcN+C6OlFI2cNVPYwqSpWpx5llZiHd9s+/7ORl+iyFAK
         Y7+eUtiKYzdo1J6ov7vYpbsgE5auNocFcpFZ6uqE=
Received: by mail-wr1-f43.google.com with SMTP id u3so15832792wrs.3
        for <linux-sgx@vger.kernel.org>; Tue, 11 Dec 2018 15:11:06 -0800 (PST)
X-Gm-Message-State: AA+aEWZux8i0RjUi9SYcBqEen5wiq72GgN9EqsFhQAIZOCB5wsLACNTy
        7ualRX9wn+VZKiCZ+dQ7HuVdaBN4wdP/63yFOfsJ1w==
X-Google-Smtp-Source: AFSGD/Vrs98aBUZmb1AMf3oTyrdOtumA5orJMEfXeXCUtQTK8KKSRP+e4PHnvoLOBxRfmLqtUuOdFJzvI2U3SFVFqN8=
X-Received: by 2002:adf:8323:: with SMTP id 32mr14522736wrd.176.1544569864592;
 Tue, 11 Dec 2018 15:11:04 -0800 (PST)
MIME-Version: 1.0
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
 <20181210232449.GA11843@localhost> <EEE078E7-7F37-4F74-8874-46E16C1E0A77@amacapital.net>
 <20181211165253.GB14731@linux.intel.com> <CALCETrXOXh8Gb_d7NYLakx4w+JVEe79t11wFPLpy+5MEq9kq=A@mail.gmail.com>
 <20181211222312.GI14731@linux.intel.com>
In-Reply-To: <20181211222312.GI14731@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Dec 2018 15:10:52 -0800
X-Gmail-Original-Message-ID: <CALCETrW5Z_4+Yo+D1KgahHHqGdb+tgyWMRvB8eozbW82jZqK3w@mail.gmail.com>
Message-ID: <CALCETrW5Z_4+Yo+D1KgahHHqGdb+tgyWMRvB8eozbW82jZqK3w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 11, 2018 at 2:23 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Dec 11, 2018 at 09:58:19AM -0800, Andy Lutomirski wrote:
> > > On Dec 11, 2018, at 8:52 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > >
> > >> On Tue, Dec 11, 2018 at 07:41:27AM -0800, Andy Lutomirski wrote:
> > >>
> > >>
> > >>>> On Dec 10, 2018, at 3:24 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > >>>>
> > >>>> On Mon, Dec 10, 2018 at 03:21:37PM -0800, Sean Christopherson wrote:
> > >>>> At that point I realized it's a hell of a lot easier to simply provide
> > >>>> an IOCTL via /dev/sgx that allows userspace to register a per-process
> > >>>> ENCLU exception handler.  At a high level, the basic idea is the same
> > >>>> as the vDSO approach: provide a hardcoded fixup handler for ENCLU and
> > >>>> attempt to fixup select unhandled exceptions that occurred in user code.
> > >>>
> > >>> So, on the one hand, this is *absolutely* much cleaner than the VDSO
> > >>> approach. On the other hand, this is global process state and has some
> > >>> of the same problems as a signal handler as a result.
> > >>
> > >> I liked the old version better for this reason
> > >
> > > This isn't fundamentally different than forcing all EENTER calls through
> > > the vDSO, which is also per-process.  Technically this is more flexible
> > > in that regard since userspace gets to choose where their one ENCLU gets
> > > to reside.  Userspace can have per-enclave entry flows so long as the
> > > actual ENLU[EENTER] is common, same as vDSO.
> >
> > Right. The problem is that user libraries have a remarkably hard time
> > agreeing on where their one copy of anything lives.
>
> Are you concerned about userspace shooting themselves in the foot, e.g.
> unknowingly overwriting their handler?  Requiring unregister->register
> to change the handler would mitigate that issue for the most part.  Or
> we could even say it's a write-once property.
>
> That obviously doesn't solve the issue of a userspace application
> deliberately using two different libraries to run enclaves in a single
> process, but I have a hard time envisioning a scenario where someone
> would want to use two different *SGX* libraries in a single process.
> Don't most of the signal issue arise due to loading multiple libraries
> that provide *different* services needing to handle signals?

I can easily imagine two SGX libraries that know nothing about each
other running in the same process.  One or both could be PKCS#11
modules, for example.

I suspect that Linux will eventually want the ability for libraries to
register exception handlers, but that's not going to get designed and
implemented quickly enough for SGX's initial Linux rollout.  A vDSO
helper like in your earlier series should solve most of the problem
without any contention issues.
