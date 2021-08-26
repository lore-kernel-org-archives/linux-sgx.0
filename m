Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6514C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C4561058
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhHZRcD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231313AbhHZRcD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 13:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1525460551;
        Thu, 26 Aug 2021 17:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629999075;
        bh=eED8CGVCOkg4g0BZmGOiANtSS6DY4UfJQhzB+Ud2Yvo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U9y2MnvmTscFIn1j/FNSewuk0C54wAN3nJ0WHj46IPOpGQegpxo7hlW8D9NrpSrgZ
         ASoAMXXjG66K3wfJ9dYQ5PtAofjhj1lnqrk2sxXa//w/0vKQ/NVBOBq9lLUgCX45ME
         tfceOJhugw0mmvpJOYV1Sj9xgA2/EA/ekfpuLmvsVQkqwvJ7l7oa/1ceZUiSKhQQMG
         u6FzRDF1bm5TSEdFwF8StOCGWcTaAYweo7KOZKVyIk0Z3mOBND8Cqzqjo237Bi+ILg
         Ynm1ce52dcuv1oOKLb+P3KenBpX1KDoc9ldhH/E0t+dBDCb/lT6ZNmCkZXBk5/VwcB
         JDwxFPCnw0lqw==
Message-ID: <3980adde9c05963790215e99d566740059da6870.camel@kernel.org>
Subject: Re: [PATCH v3 1/2] x86/sgx: Add the missing ifdef for
 sgx_set_attribute()
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 26 Aug 2021 20:31:13 +0300
In-Reply-To: <YSfOMBzWwWuefke/@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <YSdl16MFt/GVNGDq@zn.tnic>
         <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
         <YSfC2vhMxaUY2j/H@zn.tnic>
         <5a44ada347713097eb0308e0f2f2b16cb55a635f.camel@kernel.org>
         <YSfOMBzWwWuefke/@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-26 at 19:24 +0200, Borislav Petkov wrote:
> On Thu, Aug 26, 2021 at 08:11:27PM +0300, Jarkko Sakkinen wrote:
> > Is your preference is to have in set_memory.c:
>=20
> My preference is to take fixes only for actual problems which can be
> triggered with some config - not something you're doing locally.

The actual problem is to use it in set_memory.c.

This the unsplit version:

https://lore.kernel.org/linux-sgx/20210818132509.545997-1-jarkko@kernel.org=
/

Should I just squash them again into one patch?

I did the split because of earlier review comments.

/Jarkko
