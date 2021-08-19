Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8041C4320A
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 12:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6EA960ED3
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Aug 2021 12:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhHSMx2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhHSMx1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Aug 2021 08:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06665610FF;
        Thu, 19 Aug 2021 12:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629377571;
        bh=d8+ejcexdJq2YzMyuiPFlHJMiGhmSn4T29YapIhjupE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M1mbxHnDvBv+QjdxxgKadd1CmtEY8q7rdMx8qneJ3/ldYQV7pdBGM43LsjTnlCTo6
         LMkzuEPxEg/JWG64EgWSt86COIyiPNxQ+PeJ1erc94cxX8/g/FJI64FhSneUSm734v
         ixR7ummRFRy6XJMa1GxFwc3OYVfdZGmK87sEAm/eXQz9vL+ixXwCe52pGMwg+IzRKX
         cRs3zRaApBS+6Xn+0V36tPyjHFkdS4toGcPGo7rhk3DsthZ7nSN0tYmvZmnf2sHOEx
         Fy8yPcqsNpdc+nj39lIruE/bhkXDG1D5k5dsLDs4UjFiRUvsaE58Xc+LdsT/oJjNp3
         Oq81RaicLtJTQ==
Message-ID: <9ec30322d0d133bfa695da475d4de736994a6c68.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Saravanan D <saravanand@fb.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Thu, 19 Aug 2021 15:52:48 +0300
In-Reply-To: <20210819124824.52169-2-jarkko@kernel.org>
References: <20210819124824.52169-1-jarkko@kernel.org>
         <20210819124824.52169-2-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-19 at 15:48 +0300, Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
>=20
> Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
> usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> BIOS, the printout would be:
>=20
> SGX_MemTotal:      22528 kB
>=20
> It is less than 32 MB because some of the space is reserved for Enclave
> Page Cache Metadata (EPCM), which contains state variables for all the
> pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> which applications can use to create enclaves.
>=20
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

While working on this, I noticed that suddenly my i5-9660k desktop fully
supports SGX on Linux. I don't recall that it has worked in the patch.
Maybe this is because of some firmware/ucode update, do not really know,
but definitely not a bad thing.

Perhaps this casts through other 9th gen Core CPU's.

The motherboard I have in this machine is AORUS Elite z390.

/Jarkko

