Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8986C432BE
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE826103A
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 17:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhHZRMR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhHZRMR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 26 Aug 2021 13:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3713C61026;
        Thu, 26 Aug 2021 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629997889;
        bh=VZ3aS1yDrSE+BMuh2vefaRw7uQst98Pi73CImkvGDuU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MDZHP8ujhQuuK0CVDrjZ3TMVIMqj8YxhyY4mYJCb0pNNLR4t+NlLfgQg1j/K4eVL5
         EW44YLr6dZbb/4c2CJjpIvtMoW0covnESWcQGIaSnwWqMlZ0/IHxK+fTd1EjyjZNp0
         Leyu+JIkfyD1nLxf+Z2Qu2iTG641DpVJH79FYUynuTiP9G0EaI/B+P+Z/POxQrrxuZ
         I7cbI9Rq4mb9R15GWslBfhpmpSIBL/jL5CE/6SBzWlzSdpVUpFAztneFtRAYzy2X16
         mgTR7dzt8vvL7S0c2EeNlKYahizyYrpkK5AMjNjs54VqT8QW3Ji9g4l5KFrAaW0Fp5
         bHRQw6FgnFlgg==
Message-ID: <5a44ada347713097eb0308e0f2f2b16cb55a635f.camel@kernel.org>
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
Date:   Thu, 26 Aug 2021 20:11:27 +0300
In-Reply-To: <YSfC2vhMxaUY2j/H@zn.tnic>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <YSdl16MFt/GVNGDq@zn.tnic>
         <a006c85ef21f4dbd46a2ec1f73fa4e273afc5f6c.camel@kernel.org>
         <YSfC2vhMxaUY2j/H@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-26 at 18:35 +0200, Borislav Petkov wrote:
> On Thu, Aug 26, 2021 at 07:08:07PM +0300, Jarkko Sakkinen wrote:
> > I made this change because I'm including the header to set_memory.c, an=
d
>=20
> This is something you're doing locally, I presume. If so, you can keep
> this patch local too.
>=20
> > It's also incoherent that KVM specific functions are compilation flagge=
d
>=20
> They don't really have to be - they're just declarations.

Let me check.

Is your preference is to have in set_memory.c:

#ifdef CONFIG_X86_SGX
#include <asm/sgx.h>
#endif

instead of doing this in uapi/asm/sgx.h?

/Jarkko
