Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBAFC43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACF9206CC
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 21:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TK0EwZqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgC3Vmo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 17:42:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:44862 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgC3Vmo (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 30 Mar 2020 17:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585604563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZJORZCK8mEFbVyxtEKusnwB2wC62iBB4NfuKVX76FDE=;
        b=TK0EwZqQG0dnDChv1A/K99jWeOBYL7Oej1fAgDRBrHhqe0BZmB2wkmvuaIEQwQgUQGmcK+
        HrpENc5WiBSoWVWKu4/MqZM2oUj0yKQbNK0x51G0MRsSTLP6mFigHsd4eGOuMkxkKJ6GEc
        pjFSo2tjlr77Fcx96ujWu8nwmqcKN8Q=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-4Xz-q174OkGtpoCEfZiAKQ-1; Mon, 30 Mar 2020 17:42:41 -0400
X-MC-Unique: 4Xz-q174OkGtpoCEfZiAKQ-1
Received: by mail-il1-f197.google.com with SMTP id m2so18084549ilb.21
        for <linux-sgx@vger.kernel.org>; Mon, 30 Mar 2020 14:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJORZCK8mEFbVyxtEKusnwB2wC62iBB4NfuKVX76FDE=;
        b=pzozk48gHBrjX7nUevgUQ9TKjcaYxbH7oI8hFWlDCnXy5HvHpw2IT/0KoSrcx9Ul66
         Mdk5HvLZZFGH25qlnxUCIoyjadOpE/fA7EsHkFQgd6HOFhTiyVaB6YhiiPq/Mr8YiuBv
         NqttoIIbzWF1dOimlhZXADb7sZbK4TL6nbZSOmhkz3EEU9kGoMLvGSrUyr8ycm4eD0Q7
         QucTh9PGwAF4S4Ni3cxg73z6HkKEY8UbXRftygIbAm2S80r1+IX3SBMeCqr23C1lt7gw
         6jhXviyHudl2VMrRhtKHgAIVNze/JlUhLNOJEWCVeBcAXoApFaVi2eudQiiPTX/WsbbV
         VP4A==
X-Gm-Message-State: ANhLgQ2Lfqglq2a7UBIIQGfbg7mIpF7JxkA+sa6g/L2xTf6RJxk6DrSC
        j8WW7o0r+fx2lKqaKRlXmFBzPpsll5WXjOaK2VDz1WoPFgOn+AvgjipDNQaqQpw5ukWsQBCYp0r
        uqW9nvcqcd6Crm991OYutx9NfKikBSnPpQslo
X-Received: by 2002:a6b:f404:: with SMTP id i4mr12359123iog.175.1585604560988;
        Mon, 30 Mar 2020 14:42:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvYJFXPt5FzjYwAnyeVK0J/WgL6L4UWB9mBzh6EBmeSzRXgq7CJqXhjtsLXp2/pzd00oHOsB710+GA4XHOBQeE=
X-Received: by 2002:a6b:f404:: with SMTP id i4mr12359106iog.175.1585604560677;
 Mon, 30 Mar 2020 14:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200330180811.31381-1-sean.j.christopherson@intel.com> <20200330204839.GH1384380@linux.intel.com>
In-Reply-To: <20200330204839.GH1384380@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Mon, 30 Mar 2020 17:42:29 -0400
Message-ID: <CAOASepPxHCh_SfA3krurq5oQaikZ7YpyDqcW9A6RQ_E5OoMn+Q@mail.gmail.com>
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

On Mon, Mar 30, 2020 at 4:48 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Mon, Mar 30, 2020 at 11:08:06AM -0700, Sean Christopherson wrote:
> > Nathaniel pointed out that __vdso_sgx_enter_enclave() is tantalizingly
> > close to being callable from C (with caveats and a cooperative enclave).
> > The missing pieces are preserving %rbx and taking @leaf as a standard
> > parameter.
> >
> > v2:
> >   - Rebase to Jarkko's latest master, commit 402fb35a477a, "docs: ...")
> >   - Add CFI directive for RBX. [Cedric]
>
> I'm sorry for throwing stick's constantly but I think having a real
> ELF loader is for better.

Why is it one or the other?

