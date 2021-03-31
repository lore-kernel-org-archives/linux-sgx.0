Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9046C433C1
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 06:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937B1619D6
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 06:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhCaGoi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 02:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbhCaGo3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Mar 2021 02:44:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF43C061574;
        Tue, 30 Mar 2021 23:44:29 -0700 (PDT)
Received: from [10.164.192.140] (dynamic-002-247-240-140.2.247.pool.telefonica.de [2.247.240.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CC01A1EC0249;
        Wed, 31 Mar 2021 08:44:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617173066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAxY46mFIenqAABqpPFYj+vN+DMFJ4V7PQk1qZNFIOw=;
        b=Ub9Uku0zCj/UrLx3u7rWxbZaDyIeBSC+JosQugALaAG7V+qGJZ4IBbySmyK2YiL4W1hEDn
        TU52gW4VIOn2DW9SJEaGoRKYZQFS/t8M0CRJAu9GZFqcmQsaqJrqyaxG2J4uZvyyi+xUtR
        guvO2naUdOQBzBwLy1eDSzPt6uDXB1E=
Date:   Wed, 31 Mar 2021 08:44:23 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com> <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com> <20210326150320.GF25229@zn.tnic> <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM guests
To:     Kai Huang <kai.huang@intel.com>
CC:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
From:   Boris Petkov <bp@alien8.de>
Message-ID: <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On March 31, 2021 3:10:32 AM GMT+02:00, Kai Huang <kai=2Ehuang@intel=2Ecom>=
 wrote:=20

> The admin will be aware of
>such EPC
>allocation disjoint situation, and deploy host enclaves/KVM SGX guests
>accordingly=2E

The admin will be aware because=2E=2E=2E

1) he's following our discussion?

2) he'll read the commit messages and hopefully understand?

3) we *actually* have documentation somewhere explaining how we envision t=
hat stuff to be used?

Or none of the above and he'll end up doing whatever and then he'll eventu=
ally figure out that we don't support that use case but he's doing it alrea=
dy anyway and we don't break userspace so we have to support it now and we'=
re stuck somewhere between a rock and a hard place?

Hmm, I think we have enough misguided use cases as it is - don't need anot=
her one=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
