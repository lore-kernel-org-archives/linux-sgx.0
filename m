Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFE5C432BE
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Aug 2021 01:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F04E61073
	for <linux-sgx@archiver.kernel.org>; Tue, 24 Aug 2021 01:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhHXBQ5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 23 Aug 2021 21:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhHXBQ5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 23 Aug 2021 21:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B773C61027;
        Tue, 24 Aug 2021 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629767774;
        bh=ekDtvYKAlbCftbuIBYVlLpODh9IVH8ezEybZDfXZKlM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fTTCaiLL+T5+TNhz7WyeJwCMVO+UMsQirJiA62/vVpGhfr5GM1IEuEKB7GCRpC1M3
         heCvYdSXOGKGSBJAQIRW0dNXG+GLfdbBhfJjcrtXwi/DnRnYsH5jiokSjeozU3SNGY
         1p4totkh9wf3fvB+QHFePJ1AYMMoPIiN8x+dWDc0jDzmRDcUA+bhAyGck2LqPKWJ2e
         6acukbqbxBVURrsSkJhym861m+PmkZvHLbviFn6ru2/kXOK48F2CSddmBCbFLKUF7i
         U1APV72lCXW/a4GaTEbXMlQPEsOySFEG5EnAQpDWgDeHYvfKAp/ZjjTmwaxqjbihD3
         u3NkeNUgYbTxg==
Message-ID: <e0522fa59b2029d6a2210c1113919b572746f794.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Add SGX_MemTotal to /proc/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org
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
        Saravanan D <saravanand@fb.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Date:   Tue, 24 Aug 2021 04:16:11 +0300
In-Reply-To: <8e6e42b0-0a1e-6892-b601-ce4a94172ef1@intel.com>
References: <20210818132509.545997-1-jarkko@kernel.org>
         <8e6e42b0-0a1e-6892-b601-ce4a94172ef1@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-08-23 at 08:15 -0700, Dave Hansen wrote:
> On 8/18/21 6:25 AM, Jarkko Sakkinen wrote:
> > The amount of SGX memory on the system is determined by the BIOS and it
> > varies wildly between systems.  It can be from dozens of MB's on deskto=
ps
> > or VM's, up to many GB's on servers.  Just like for regular memory, it =
is
> > sometimes useful to know the amount of usable SGX memory in the system.
> >=20
> > Add SGX_MemTotal field to /proc/meminfo, which shows the total amount o=
f
> > usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> > BIOS, the printout would be:
> >=20
> > SGX_MemTotal:      22528 kB
>=20
> The big question here: Do we want to put purely architecture-specific
> entries in (the currently quite arch-independent) /proc/meminfo?
>=20
> The current "DirectMap4k/2M/1G" entries from arch_report_meminfo() are
> arch-specific in their sizes, of course, but the concept is at least
> quite arch-independent.

I started with /proc/meminfo instead of /sys/devices/system/node/*/meminfo
because there is pre-existing arch callback, and secondary because it's als=
o
better fit for my kselftest code.

The same discussion still applies to both files, they probably should follo=
w a
matching pattern.

/Jarkko

