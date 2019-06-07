Return-Path: <SRS0=ZwJT=UG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A46C2BCA1
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jun 2019 19:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EEB8208C0
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Jun 2019 19:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="ZPB8NP7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfFGTc0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Jun 2019 15:32:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39300 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729081AbfFGTcZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 7 Jun 2019 15:32:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so1663727pgc.6
        for <linux-sgx@vger.kernel.org>; Fri, 07 Jun 2019 12:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UaxnOWMtOkiVXOn0khlY9DVhEFKpsvUcRqCZpkBYkIA=;
        b=ZPB8NP7E+xSXPMfJhmbeQD/KyVehlbnJ7mKrX+TDFWriLPfm9rg4DKcMQZ1xpMTufO
         YhQXtEqBVu9tWgpg1xK/aaXmSJigHWyOTp+q4bVgxadHdCpne7hiwUHaAfaQOwgX5gZP
         i5CM52dNVxqvYQUjrM/VbVjzhBE4qXBYqiMvuVB0lDnyOS4e97Zc0q6YeCCqQ597KX45
         hoxMb+94ArAc2Z+bFXhb+PZ+Cz4NGMergo+M3jum0JzxPnrvx6+s04TNNjnRPkzO/e0c
         bJ+eFcCqrk6ju3IiOmW2rlp3g0s6nyLMQRHI0I9fIqxLCcBWYLAZ60t+l6wyGdibKh0I
         Qhjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UaxnOWMtOkiVXOn0khlY9DVhEFKpsvUcRqCZpkBYkIA=;
        b=HSRajRufpjBx+Rf6rakV2X0TEc4ctjG1lAUmQIDRxbwaA5QesNRHKMPNQZGDQYQCBg
         5/Y+JhO7cuXacV1na5jBDf9tgY0Yk3WRMxzzrrH+YFfbwaYEZQM01w5FvbpWf1C0+PDj
         DdHWXi9hDLbzAB3VlAovz7HBcSCwuiAR0cH5Uo2Ba60COAtwvjJqeAbUnTz4XJNXj6DC
         VdpQkzsuapu5d/msJL857+l2ZrchestosVrXG53ER2izBflz2HRT9KWvyQLPKmH/qwN3
         21YjYWeUDN6lSp7Sl2XFuWOnlGOR9OWmVaSvdlKSkyCVAR5RxIaegfFYd6btHt1Mwe1N
         5oiA==
X-Gm-Message-State: APjAAAWVw1laGpBNvaXxksticdYmw47MN8q3E2HfIA5AFvZbY2Kbrsh4
        Zmgym1bamMv+xsXRu8hJnvRRBQ==
X-Google-Smtp-Source: APXvYqyPEoqLUzubBHa0NaR0NNlZNAn2gYVQRNv6c0zFtp9nCv78PBJeqW2y8u61AIKFhUhFXrs9QA==
X-Received: by 2002:a62:5c84:: with SMTP id q126mr34372801pfb.247.1559935945052;
        Fri, 07 Jun 2019 12:32:25 -0700 (PDT)
Received: from ?IPv6:2600:1012:b044:6f30:60ea:7662:8055:2cca? ([2600:1012:b044:6f30:60ea:7662:8055:2cca])
        by smtp.gmail.com with ESMTPSA id c6sm6081904pfm.163.2019.06.07.12.32.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 12:32:24 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of copying from source
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <20190606173243.GE23169@linux.intel.com>
Date:   Fri, 7 Jun 2019 12:32:23 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A948B013-BCA7-4C76-B816-CC27F38BF761@amacapital.net>
References: <20190605194845.926-1-sean.j.christopherson@intel.com> <20190605194845.926-6-sean.j.christopherson@intel.com> <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com> <20190606173243.GE23169@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On Jun 6, 2019, at 10:32 AM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
>> On Thu, Jun 06, 2019 at 10:20:38AM -0700, Andy Lutomirski wrote:
>> On Wed, Jun 5, 2019 at 12:49 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>>=20
>>> For some enclaves, e.g. an enclave with a small code footprint and a
>>> large working set, the vast majority of pages added to the enclave are
>>> zero pages.  Introduce a flag to denote such zero pages.  The major
>>> benefit of the flag will be realized in a future patch to use Linux's
>>> actual zero page as the source, as opposed to explicitly zeroing the
>>> enclave's backing memory.
>>>=20
>>=20
>> I feel like I probably asked this at some point, but why is there a
>> workqueue here at all?
>=20
> Performance.  A while back I wrote a patch set to remove the worker queue
> and discovered that it tanks enclave build time when the enclave is being
> hosted by a Golang application.  Here's a snippet from a mail discussing
> the code.
>=20
>    The bad news is that I don't think we can remove the add page worker
>    as applications with userspace schedulers, e.g. Go's M:N scheduler,
>    can see a 10x or more throughput improvement when using the worker
>    queue.  I did a bit of digging for the Golang case to make sure I
>    wasn't doing something horribly stupid/naive and found that it's a
>    generic issue in Golang with blocking (or just long-running) system
>    calls.  Because Golang multiplexes Goroutines on top of OS threads,
>    blocking syscalls introduce latency and context switching overhead,
>    e.g. Go's scheduler will spin up a new OS thread to service other
>    Goroutines after it realizes the syscall has blocked, and will later
>    destroy one of the OS threads so that it doesn't build up too many
>    unused.
>=20
> IIRC, the scenario is spinning up several goroutines, each building an
> enclave.  I played around with adding a flag to do a synchronous EADD
> but didn't see a meaningful change in performance for the simple case.
> Supporting both the worker queue and direct paths was complex enough
> that I decided it wasn't worth the trouble for initial upstreaming.

Sigh.

It seems silly to add a workaround for a language that has trouble calling s=
omewhat-but-not-too-slow syscalls or ioctls.

How about fixing this in Go directly?  Either convince the golang people to a=
dd a way to allocate a real thread for a particular region of code or have t=
he Go SGX folks write a bit of C code to do  a whole bunch of ioctls and hav=
e Go call *that*.  Then the mess stays in Go where it belongs.=
