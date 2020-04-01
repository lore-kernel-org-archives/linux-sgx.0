Return-Path: <SRS0=Q2Hp=5R=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0162C2D0F0
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 13:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55062078C
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Apr 2020 13:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V0BSUSqH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgDANGx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 1 Apr 2020 09:06:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732652AbgDANGx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 1 Apr 2020 09:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585746412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZ4ny+cMF4u7XMwScLW8wMAdB1ZvvnofNcZj7n4qgvI=;
        b=V0BSUSqHTBtZHtbOm7smKoClhlqGZHb9dG2NO0ylKjwfMM7f01DZ20hx7hXnmRiE+1NdA0
        RsVLcoU9CanhMWI8k/fiK/HfZ6gAWgJe3GWPIrrId+x4WR+XurN4d+GxToAHQTKuz1OmEC
        0IE2aJSvqO126zo+gJkYjG7yek+h3vk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-OijR3PbNPdWgd737yaVhug-1; Wed, 01 Apr 2020 09:06:50 -0400
X-MC-Unique: OijR3PbNPdWgd737yaVhug-1
Received: by mail-io1-f69.google.com with SMTP id c2so22296814iok.14
        for <linux-sgx@vger.kernel.org>; Wed, 01 Apr 2020 06:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZ4ny+cMF4u7XMwScLW8wMAdB1ZvvnofNcZj7n4qgvI=;
        b=MUTjBq137/M9UUMF8irPAQZlIfCnKqiKD7KnxJ88TGKFE4AXw/O7qniBr6jl6Ty/Kd
         xa5FriTGzAf+6nvu+c7UMDwXCsgX8vsyTSjrVQfrA3N8nR2uvibNnWiE9L44oXATHXiK
         5pRqaoOTeyfFVpU+qwY89yHNPsKb+QCVJSnCLQSLL95CB2hJp4EvdMtaDWZCDD6GK2B/
         Un95y3UUPyOnrOZlx8Sj8VMJqhz/rsezSJLAeXi2IAv1VkyN0gHM6rET3toT/OAZrI9D
         hLj6CWcCRo8Ghz6zFP7vvZ2+7XZnrmyP+kTTjmq4E5PpGAN9sU3UnZEnZZkjgEJ9tvjK
         XnYg==
X-Gm-Message-State: ANhLgQ1faspb4w3cgmf75L8e4x7K9WJlM/TpplUoUDSoj4MqQYMjRINf
        8QsBEbGP7a0aCKTnx46vsKhs+4uPSqS1r79445ijQjvVrbhlgjJsEnaakAsuIEhW6nyKXO1uhlG
        bv8q0r7Of7wHI1ZGSRGM9n4K10h6TMilAamA5
X-Received: by 2002:a02:c851:: with SMTP id r17mr2486434jao.67.1585746410068;
        Wed, 01 Apr 2020 06:06:50 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsJyAW/2SAGFcO/xqhxN8I3v9Chf/Wy2FWo/O0/nesVhVc2Iddhd22rY0knXnwICPSQu5RhaSBjJg3+Q/CnMsw=
X-Received: by 2002:a02:c851:: with SMTP id r17mr2486349jao.67.1585746408926;
 Wed, 01 Apr 2020 06:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
 <20200330204839.GH1384380@linux.intel.com> <CAOASepPxHCh_SfA3krurq5oQaikZ7YpyDqcW9A6RQ_E5OoMn+Q@mail.gmail.com>
 <20200331115822.GD8295@linux.intel.com> <CAOASepPgNWHg8RVAU5b6CDE4K6LwhiHHdHUiN57ay6T+xAx7Ow@mail.gmail.com>
 <20200401081756.GA17325@linux.intel.com>
In-Reply-To: <20200401081756.GA17325@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Wed, 1 Apr 2020 09:06:38 -0400
Message-ID: <CAOASepNRgy7Fo7iU0Y=bpFXpA-WfY--d6LL1rKMZSm79SDK+gw@mail.gmail.com>
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

On Wed, Apr 1, 2020 at 4:18 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Mar 31, 2020 at 09:40:24AM -0400, Nathaniel McCallum wrote:
> > On Tue, Mar 31, 2020 at 7:58 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Mon, Mar 30, 2020 at 05:42:29PM -0400, Nathaniel McCallum wrote:
> > > > On Mon, Mar 30, 2020 at 4:48 PM Jarkko Sakkinen
> > > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > >
> > > > > On Mon, Mar 30, 2020 at 11:08:06AM -0700, Sean Christopherson wrote:
> > > > > > Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> > > > > > close to being callable from C (with caveats and a cooperative enclave).
> > > > > > The missing pieces are preserving %rbx and taking @leaf as a standard
> > > > > > parameter.
> > > > > >
> > > > > > v2:
> > > > > >   - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
> > > > > >   - Add CFI directive for RBX. [Cedric]
> > > > >
> > > > > I'm sorry for throwing stick's constantly but I think having a real
> > > > > ELF loader is for better.
> >
> > This statement seems like you are juxtaposing having
> > __vdso_sgx_enter_enclave() be potentially C-compatible with having an
> > ELF-loader. These are not incompabile. __vdso_sgx_enter_enclave() can
> > be C-callable *and* you can have an ELF loader.
>
> I'm not honestly sure what this is about but my comment was about heavy
> rebasing of the GIT tree as I rewrote the selftest last week.

Okay. Let's chalk it up to miscommunication then. :)

