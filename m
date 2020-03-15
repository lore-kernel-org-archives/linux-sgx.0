Return-Path: <SRS0=qxyk=5A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D70C10F29
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 17:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47A6D20637
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 17:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hs+O8py0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgCORxu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 15 Mar 2020 13:53:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38666 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729013AbgCORxt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 15 Mar 2020 13:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584294828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4sCAV6YPEIN4XPv5c8gxRua4pipL3WppoMnmoXzPK/Y=;
        b=hs+O8py0nbeeWm60XEb/WwbhYfkMfd7tJvbpyMY8G8VUux1RJhmcOEJmEBLnJezYEva/yQ
        v3JLz5fzNWeiUaYQAxFR1qfOFXnrH+FLo+n9piDsh8k5Zw+GiFOf8ooxCu/bumnisC07h/
        rWardxFkabR5o+BVdXMFNnYLWc0jhKM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-7LCk8MD1OJytVNP8yQQxcg-1; Sun, 15 Mar 2020 13:53:44 -0400
X-MC-Unique: 7LCk8MD1OJytVNP8yQQxcg-1
Received: by mail-io1-f70.google.com with SMTP id h76so4333667iof.12
        for <linux-sgx@vger.kernel.org>; Sun, 15 Mar 2020 10:53:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4sCAV6YPEIN4XPv5c8gxRua4pipL3WppoMnmoXzPK/Y=;
        b=lrx5sShEzO7CEx094HMznZj2QIOkEB6yWK0mLq0pK7tOkyWHttpn4+F49Cs65b0dFr
         gIZB1ppxWuAk619ZKKhak1AKy40yZ5EUunZDOv8TqNTb9Sk9+tuhVZf5TrL9YlrWjdu4
         YXB0uMHeXPOA1x9KeK3BEiOAempVStl88CfROibjaWj16VtB0gU8c+o148Ze3rhvQFRl
         wmOxo0/ZJc3nYKt3GaZlWlmj2MXLtLHQecR2/te+ElEaa8oHNVkT1YQzqWb6N/pr9OpJ
         QkPSfo4a6mkP/RY0e6loVLRhzCsk/Vq4/5uHS+CGrueMg78S2ze/bcDQcIBPcDT5ramq
         kCHA==
X-Gm-Message-State: ANhLgQ0FVshSi+H0Fs5OmUcMtihPjasQ2mITX90u9/94ydocd7ODOkku
        6HkVQbMTyTIlMj3i03rUfnPQ8Ue2xwRkllPZSouDDRMOWLkuvqiWB2SRijgSCeG0DrZejHz88zw
        H3XGMi9OzybGs08xHc5hVCHKU/zJNf4ivmizm
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr24142752ils.86.1584294824283;
        Sun, 15 Mar 2020 10:53:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv5rfYob+x+SH8BDGDVnTOHAxWdTolLX/Uz7HHyi5g6stxSZI9yXG9waJeMX3XmVStg/i9g2MSrXdDSJkvVEns=
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr24142734ils.86.1584294824017;
 Sun, 15 Mar 2020 10:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com> <20200315012523.GC208715@linux.intel.com>
In-Reply-To: <20200315012523.GC208715@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Sun, 15 Mar 2020 13:53:33 -0400
Message-ID: <CAOASepP9GeTEqs1DSfPiSm9ER0whj9qwSc46ZiNj_K4dMekOfQ@mail.gmail.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Mar 14, 2020 at 9:25 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
> > Currently, the selftest has a wrapper around
> > __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> > registers (CSRs), though it uses none of them. Then it calls this
> > function which uses %rbx but preserves none of the CSRs. Then it jumps
> > into an enclave which zeroes all these registers before returning.
> > Thus:
> >
> >   1. wrapper saves all CSRs
> >   2. wrapper repositions stack arguments
> >   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
> >   4. selftest zeros all CSRs
> >   5. wrapper loads all CSRs
> >
> > I'd like to propose instead that the enclave be responsible for saving
> > and restoring CSRs. So instead of the above we have:
> >   1. __vdso_sgx_enter_enclave() saves %rbx
> >   2. enclave saves CSRs
> >   3. enclave loads CSRs
> >   4. __vdso_sgx_enter_enclave() loads %rbx
> >
> > I know that lots of other stuff happens during enclave transitions,
> > but at the very least we could reduce the number of instructions
> > through this critical path.
>
> What Jethro said and also that it is a good general principle to cut
> down the semantics of any vdso as minimal as possible.
>
> I.e. even if saving RBX would make somehow sense it *can* be left
> out without loss in terms of what can be done with the vDSO.

Please read the rest of the thread. Sean and I have hammered out some
sensible and effective changes.

