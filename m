Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF308C432BE
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 01:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA3B6102A
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 01:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhIABwd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Aug 2021 21:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231396AbhIABwc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Aug 2021 21:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 528CE603E7;
        Wed,  1 Sep 2021 01:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630461093;
        bh=gb/1unkAc9WQ2sT+GelqEJ3c22adTLm706zednkOQEw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nU/H0oeaCGLEA0f4B4LE4YcVelCG6G+6TQDM8/z/p4lX/dpMNroB67DODnyABRi61
         js97TW1yh59iqE9Kpje+NfsPs0cfHPR3ZQlmrbbd6spyyhPvuu/aF98LkBXPusqSEw
         mOYf512S81QzSGPviIzGG5qYypr4+TLD54Lrb4mapckSzuUVj++l27ZgeLz0CZ1ygs
         IcBuTNfJE39aqu74Q8aXjKS8Sq7CUGV9j2iL44fwL2rFwfPbSPOQ7u7XAYuNav8PMG
         fy36hUILm8SO/djpgeMjeBpS3n5PjyLg/chCyKu2jMY/q8BrSllWFa8H7Yo2GD6m/E
         Xnhu8ur1KuNZQ==
Message-ID: <4c98877510a663ce52b57e9a09efbd476008b112.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date:   Wed, 01 Sep 2021 04:51:31 +0300
In-Reply-To: <124ad6ff-ee0d-5d59-0857-f1355578b59b@infradead.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
         <20210825235234.153013-2-jarkko@kernel.org>
         <ba483b7e-19a3-d4d3-56c0-3371a77341cb@infradead.org>
         <e1ff36db0e7ed909653b6adb45094cc459dbad0b.camel@kernel.org>
         <e87c5c8f-dead-ebdc-62f1-aa635288671c@intel.com>
         <124ad6ff-ee0d-5d59-0857-f1355578b59b@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-08-26 at 15:27 -0700, Randy Dunlap wrote:
> On 8/26/21 1:27 PM, Dave Hansen wrote:
> > On 8/26/21 9:17 AM, Jarkko Sakkinen wrote:
> > > > I would prefer to see this listed in Documentation/filesystems/proc=
.rst
> > > > as an optional field, depending on CONFIG_X86_SGX.
> > > > Or at least put a reference in proc.rst to this doc file and its
> > > > supplemental fields.
> > > >=20
> > > > thanks.
> > > I *can* put it there but I did have reason not to, i.e. these attribu=
tes
> > > are neither there:
> > >=20
> > > DirectMap4k:     3930904 kB
> > > DirectMap2M:    29440000 kB
> > > DirectMap1G:     1048576 kB
> > >=20
> > > And they are implemented in arch specific code.
> > >=20
> > > Actually they are undocumented, e.g.
> > >=20
> > > $ git grep DirectMap4k
> > > arch/powerpc/mm/book3s64/pgtable.c:     seq_printf(m, "DirectMap4k:  =
  %8lu kB\n",
> > > arch/s390/mm/pageattr.c:        seq_printf(m, "DirectMap4k:    %8lu k=
B\n",
> > > arch/x86/mm/pat/set_memory.c:   seq_printf(m, "DirectMap4k:    %8lu k=
B\n",
> >=20
> > Yeah, we need to add some arch-specific sections to the documentation.
> > That *could* just be a reference over to a new file:
> >=20
> > 	Documentation/x86/meminfo.rst
> >=20
> > along with whatever other arches provide their own fields too.
> >=20
>=20
> Yes, either way works. Thanks.

I'm wondering why /sys/devices/system/node/nodeX/meminfo is not
documented?  At least I could not find its documentation anywhere.

It would actually make more sense not to add anything at all
/proc/meminfo but rather add SGX_MemTotal to
/sys/devices/system/node/nodeX/meminfo because it is easy enough for
user space to calculate the final value. It's just a sum of constants
(no races).

Given the per-node granularity, maybe the arch-specific documentation
should be in Documentation/x86/node-meminfo.rst?

So I'm thinking to drop /proc/meminfo change and report SGX stats only
per-node.

/Jarkko

