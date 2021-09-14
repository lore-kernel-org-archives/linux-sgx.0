Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3AAC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 17:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6237860F92
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 17:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhINRmG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Sep 2021 13:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232240AbhINRmB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Sep 2021 13:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B93DE60F8F;
        Tue, 14 Sep 2021 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631641244;
        bh=EzZDoF30MzEUn6e4oBtOzLUhWr7xrJlJQpF3bHQ6iLo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c+SZExoXvu3xdkTXcvU/eTvPsgZaMOP7COPII0rX+88yE+ZV3eI8MnYLheo18HPTt
         1Txn87MoCy57FDft/GCi2phfvIEJZviKs95/Jrn6ntWxjPDRSi4C/7ulsm7EW79LXb
         vfNuiLK9VHhbCMW9A1r2CWsZnBnxpZNt48sYrrBnbnO2OsvB2MxFhV6euySp4lqYhV
         eHP01W7AF/WuwolYokd3ecsR3U17gfQ+ePccBHuZeu6DFSRKYT78NehnRy9uhPZupT
         JSazwj8Exr/TgRwGesYfLHWp7RRRHyvYv4OAT4nmWTKD5qrsq1FHeFjgWVVgh5JsV5
         rErmDQvTVJnIw==
Message-ID: <b87fbe2fe213976fa43fb82d5d483da8e6b1bc63.camel@kernel.org>
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE
 all pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com
Date:   Tue, 14 Sep 2021 20:40:41 +0300
In-Reply-To: <1afa3ed3-d77b-163d-e35e-30bf4f5d3a9e@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210914071030.GA28797@yangzhon-Virtual>
         <8e1c6b6d-6a73-827e-f496-b17b3c0f8c89@redhat.com>
         <fb04eae72ca0b24fdb533585775f2f20de9f5beb.camel@kernel.org>
         <1afa3ed3-d77b-163d-e35e-30bf4f5d3a9e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 2021-09-14 at 19:07 +0200, Paolo Bonzini wrote:
> On 14/09/21 18:42, Jarkko Sakkinen wrote:
> > > Let's wait for this patch to be accepted first.  I'll wait a little m=
ore
> > > for Jarkko and Dave to comment on this, and include your "Tested-by".
> > >=20
> > > I will also add cond_resched() on the final submission.
> > Why these would be conflicting tasks? I.e. why could not QEMU use
> > what is available now and move forward using better mechanism, when
> > they are available?
>=20
> The implementation using close/open is quite ugly (destroying and=20
> recreating the memory block breaks a few levels of abstractions), so=20
> it's not really something I'd like to commit.

OK, so the driving reason for SGX_IOC_VEPC_RESET is the complex dance
with opening, closing and mmapping() stuff, especially when dealing
with multiple sections for one VM? OK, I think I can understand this,
given how notorious it might be to get stable in the user space.

Please just document this use case some way (if I got it right) to
the commit message of the next version, and I think this starts to
make much more sense.

/Jarkko
