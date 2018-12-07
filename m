Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35335C64EB1
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 17:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED28B20892
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544205388;
	bh=eYA6Un5E3SjnCQ/0lna2qchuwKY1UJ/Zte/umEg/5hA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IheZHIdk0NdxhAfo/TKwvJiqdoGEdUMel45g0LmHfzPtLEgr/RJcGPzb03eBbgr1x
	 tneCKtLEfb+JnF0D2MTvoMK+FTuTd/Cd7C4D1kEQJx1FDFUzE1MVYyt6IXfBCtwnVr
	 QJIW5NxzX5EHQq15GLvUh3k8PTos7FWPFVpZQvXc=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED28B20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbeLGR41 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 12:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbeLGR40 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 12:56:26 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3096920892
        for <linux-sgx@vger.kernel.org>; Fri,  7 Dec 2018 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544205385;
        bh=eYA6Un5E3SjnCQ/0lna2qchuwKY1UJ/Zte/umEg/5hA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I5+jkLMqLZ9muw1OqFQCOb/FHJgnnAvBxvlLcBYNA9Oke2C/dk0teciiTjv5kpWyc
         xX5TC8r+2Zwzq8nRj1KhCXhQwSrRm0jemUF8gPDZif84KdZi5oPqBXc6GkrxDAomlm
         GiHXbMaP5yQPl9HlWnOGaGkcljE+M7Oe3/yiTWPw=
Received: by mail-wm1-f50.google.com with SMTP id f81so5327045wmd.4
        for <linux-sgx@vger.kernel.org>; Fri, 07 Dec 2018 09:56:25 -0800 (PST)
X-Gm-Message-State: AA+aEWYiebSm1hW0c0llmcfD9ZcCTqFYMwQue10mDqsmDBCGsYpkTwhv
        fNPYfEX6aaarJ7H4l5LfkttIrbAAIozBsAvNeErAAA==
X-Google-Smtp-Source: AFSGD/Xi/KZNxDkd+UDVtU1fnEdusNC7yKdoA8fRu/kcfNW/MwSglOeb8YgrUvnZwMmbJqU/t/Z2qChya+eFJvXaBAs=
X-Received: by 2002:a1c:f112:: with SMTP id p18mr2884558wmh.83.1544205383599;
 Fri, 07 Dec 2018 09:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com> <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
 <20181207165145.GB10404@linux.intel.com>
In-Reply-To: <20181207165145.GB10404@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 7 Dec 2018 09:56:09 -0800
X-Gmail-Original-Message-ID: <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
Message-ID: <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
Cc:     Andrew Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-sgx@vger.kernel.org, haitao.huang@linux.intel.com,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 7, 2018 at 8:51 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> +Cc: linux-sgx, Haitao, Greg and Jethro
>
> My apologies for neglecting to cc the SGX folks, original thread is here:
>
> https://lkml.kernel.org/r/20181206221922.31012-1-sean.j.christopherson@intel.com
>
> On Thu, Dec 06, 2018 at 02:50:01PM -0800, Andy Lutomirski wrote:
> > On Thu, Dec 6, 2018 at 2:19 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> >  +
> > > +       /*
> > > +        * Invoke the caller's exit handler if one was provided.  The return
> > > +        * value tells us whether to re-enter the enclave (EENTER or ERESUME)
> > > +        * or to return (EEXIT).
> > > +        */
> > > +       if (exit_handler) {
> > > +               leaf = exit_handler(exit_info, tcs, priv);
> > > +               if (leaf == SGX_EENTER || leaf == SGX_ERESUME)
> > > +                       goto enter_enclave;
> > > +               if (leaf == SGX_EEXIT)
> > > +                       return 0;
> > > +               return -EINVAL;
> > > +       } else if (leaf != SGX_EEXIT) {
> > > +               return -EFAULT;
> > > +       }
> >
> > This still seems overcomplicated to me.  How about letting the
> > requested leaf (EENTER or ERESUME) be a parameter to the function and
> > then just returning here?  As it stands, you're requiring any ERESUME
> > that gets issued (other than the implicit ones) to be issued in the
> > same call stack, which is very awkward if you're doing something like
> > forwarding the fault to a different task over a socket and then
> > waiting in epoll_wait() or similar before resuming the enclave.
>
> Ah, yeah, wasn't thinking about usage models where the enclave could
> get passed off to a different thread.
>
> What about supporting both, i.e. keep the exit handler but make it 100%
> optional?  And simplify the exit_handler to effectively return a boolean,
> i.e. "exit or continue".
>
> Something like this:
>
> notrace long __vdso_sgx_enter_enclave(u32 op, void *tcs, void *priv,
>                                       struct sgx_enclave_exit_info *exit_info,
>                                       sgx_enclave_exit_handler *exit_handler)
> {
>         u64 rdi, rsi, rdx;
>         u32 leaf;
>         long ret;
>
>         if (!tcs || !exit_info)
>                 return -EINVAL;
>
> enter_enclave:
>         if (op != SGX_EENTER && op != SGX_ERESUME)
>                 return -EINVAL;
>
>         <same core code>
>
>         /*
>          * Invoke the caller's exit handler if one was provided.  The return
>          * value tells us whether to re-enter the enclave (EENTER or ERESUME)
>          * or to return (EEXIT).
>          */
>         if (exit_handler) {
>                 if (exit_handler(exit_info, tcs, priv)) {
>                         op = exit_info->leaf;
>                         goto enter_enclave;
>                 }
>         }
>
>         if (exit_info->leaf == SGX_EEXIT)
>                 return -EFAULT;
>
>         return 0;
> }
>
>
> I like that the exit handler allows userspace to trap/panic with the full
> call stack in place, and in a dedicated path, i.e. outside of the basic
> enter/exit code.  An exit handler probably doesn't fundamentally change
> what userspace can do with respect to debugging/reporting, but I think
> it would actually simplify some userspace implementations, e.g. I'd use
> it in my tests like so:
>
> long fault_handler(struct sgx_enclave_exit_info *exit_info, void *tcs, void *priv)
> {
>         if (exit_info->leaf == SGX_EEXIT)
>                 return 0;
>
>         <report exception and die/hang>
> }
>

Hmm.  That't not totally silly, although you could accomplish almost
the same thing by wrapping the vDSO helper in another function.
