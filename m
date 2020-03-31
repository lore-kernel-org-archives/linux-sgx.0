Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B452C43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 13:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DCE92071A
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 13:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWTU4twA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgCaNkj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 09:40:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730358AbgCaNki (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 31 Mar 2020 09:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585662037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y5gujX2ii9YDhQ9rlmBNPSLUdcr5ARJYErwQiWiYEBM=;
        b=IWTU4twAgUfcnFnq85/I5JULlOVAFHugvXfy3hQn1aD++rjAHsjL4/MxxlQQ1SivTeJ+2p
        jo5lIAZqF786ApEcc41+n5hQnncB7Fu35LY56ZyR4Fp6KyopVda4qVAvqq6/kXstR3hgOC
        XQRKb+avoOeZpmJ7RyVKIX+yAcssYQs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-HpcruAcWOyGUEW3qLeHYMA-1; Tue, 31 Mar 2020 09:40:36 -0400
X-MC-Unique: HpcruAcWOyGUEW3qLeHYMA-1
Received: by mail-il1-f198.google.com with SMTP id t10so20108245ilf.2
        for <linux-sgx@vger.kernel.org>; Tue, 31 Mar 2020 06:40:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y5gujX2ii9YDhQ9rlmBNPSLUdcr5ARJYErwQiWiYEBM=;
        b=qhOA7Ae0KMEkTGZm9yTY8seQPFifx53aNOC9OxNYGya+gzvPSSQDf1phY76q7OJ1Nu
         OfMK9IQGgi7qiolS1I+P9Tq3UVdl3OYYZMPF1+G+JwUCDoRpHmHVXnVjTnYHplxcdNZg
         Wh4F2aCz72RZEiDj6i4QVVOD9b6Rotqu9DAgbZqtM6Ho0a3sb9PPLusigRDjXpbQ2R3I
         UqlVP0u38G1J1jZMSHyzi6lNPBD3w2wcY8ymVH6TVfvPt762YM2stETxmhW/Ert7reHx
         6/AK1qMENyBMT4udf9v3l5NlXhsXFHAYHCl7pKyJ5ZRXOuJcrnpvilqlRXG8I3i87aeI
         dqhA==
X-Gm-Message-State: ANhLgQ0z6g9vhi/lSY9hqFYNmR2NcJTHLEZZfx/wvdOVX3CcDrV1dLHl
        LdIooPVqPqhON9a1ga7lkpXAbHOTEDjWh5SCwHKAQAZ2u/hI1SvK+um6C1FTteEaHN+Xd8VCpPq
        gGIyGJ1L4qZZ/cS2fL6GH/Of3lFnLS7DPvnGc
X-Received: by 2002:a92:c011:: with SMTP id q17mr17040916ild.301.1585662035668;
        Tue, 31 Mar 2020 06:40:35 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsZvT2I8rFj4CqgwY/uqYgqfzc877OYtZxT2tJqgsgkxsoqLECLoFHHfzShyotvEneNgBypdj5d4DRIYkB+wEg=
X-Received: by 2002:a92:c011:: with SMTP id q17mr17040885ild.301.1585662035342;
 Tue, 31 Mar 2020 06:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330204839.GH1384380@linux.intel.com> <CAOASepPxHCh_SfA3krurq5oQaikZ7YpyDqcW9A6RQ_E5OoMn+Q@mail.gmail.com>
 <20200331115822.GD8295@linux.intel.com>
In-Reply-To: <20200331115822.GD8295@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Tue, 31 Mar 2020 09:40:24 -0400
Message-ID: <CAOASepPgNWHg8RVAU5b6CDE4K6LwhiHHdHUiN57ay6T+xAx7Ow@mail.gmail.com>
Subject: Re: [PATCH for_v29 v2 0/5] x86/sgx: Make vDSO callable from C
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 31, 2020 at 7:58 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Mar 30, 2020 at 05:42:29PM -0400, Nathaniel McCallum wrote:
> > On Mon, Mar 30, 2020 at 4:48 PM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Mon, Mar 30, 2020 at 11:08:06AM -0700, Sean Christopherson wrote:
> > > > Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> > > > close to being callable from C (with caveats and a cooperative enclave).
> > > > The missing pieces are preserving %rbx and taking @leaf as a standard
> > > > parameter.
> > > >
> > > > v2:
> > > >   - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
> > > >   - Add CFI directive for RBX. [Cedric]
> > >
> > > I'm sorry for throwing stick's constantly but I think having a real
> > > ELF loader is for better.

This statement seems like you are juxtaposing having
__vdso_sgx_enter_enclave() be potentially C-compatible with having an
ELF-loader. These are not incompabile. __vdso_sgx_enter_enclave() can
be C-callable *and* you can have an ELF loader.

> > Why is it one or the other?
>
> Hmm... Not sure I understand what you want to know.
>
> A raw binary requires a hardcoded way to interpret it. Obviously ELF
> is for better.

We (Enarx) implement an ELF loader.

