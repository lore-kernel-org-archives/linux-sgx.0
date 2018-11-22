Return-Path: <SRS0=zo89=OB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7804C43441
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Nov 2018 20:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7709E20824
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Nov 2018 20:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKaTnrYH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7709E20824
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbeKWHhm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Nov 2018 02:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731175AbeKWHhm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Nov 2018 02:37:42 -0500
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053E12087E
        for <linux-sgx@vger.kernel.org>; Thu, 22 Nov 2018 20:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542920196;
        bh=YJIfsIfdZWhokmc5AmAxS36jA+j3oNAeEQKE2BShSiI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kKaTnrYHXR4RNqmxwA4xxDx1Thw4nbVvPo8UK9Zt2T6BjMrsOhHz4K/t0/T8EhxVa
         JvZvToWW61SqIckM2t38ERyTfWgehHeVgXMbsVUsmcJMjgnBt5V4xXTUxW+NERSzOQ
         ftoc6Tvba/H69STJ7M+WQmwAjX51dbkX/U7YqWZE=
Received: by mail-wr1-f41.google.com with SMTP id j10so10424783wru.4
        for <linux-sgx@vger.kernel.org>; Thu, 22 Nov 2018 12:56:35 -0800 (PST)
X-Gm-Message-State: AA+aEWYfDt+KmzUquWWkveYi38ghjtKncalMCTiDlgaxxBGHiyZkAwou
        4ilctMqHiNjfGETukrinTrUrMsCsQGVWYoO3tFu30w==
X-Google-Smtp-Source: AFSGD/X4xwRHkaGCQhRnDTT8WFNa+XnFAtVwbkAziAz3OIBhcx3jEOHX0HVrvo882N+U03PwwJVADPYF8Skc92F2bVk=
X-Received: by 2002:adf:90af:: with SMTP id i44-v6mr10609605wri.77.1542920194516;
 Thu, 22 Nov 2018 12:56:34 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com>
In-Reply-To: <20181122111253.GA31150@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 22 Nov 2018 12:56:23 -0800
X-Gmail-Original-Message-ID: <CALCETrV4wOpk7wf9+ywd50PekGjfT7LNtwqHhcV08=oxPmKtKQ@mail.gmail.com>
Message-ID: <CALCETrV4wOpk7wf9+ywd50PekGjfT7LNtwqHhcV08=oxPmKtKQ@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     "Dr. Greg Wettstein" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 22, 2018 at 3:12 AM Dr. Greg <greg@enjellic.com> wrote:
> In addition, we are not confident
> the driver will be useful to anything other then server class hardware
> and will be incapable of supporting virtually all of the existing SGX
> hardware in the field.

I forgot to mention: I have a plain old retail Intel Celeron (I think
-- it's not in front of me right now) that has Flex LC.  I suspect
that, going forward, all new Intel CPUs will support Flex LC.  I
really wish that Intel would document all of the detailed capabilities
of all their CPUs somewhere.

There has been some talk of how the driver could support old CPUs.  It
would involve a rather different LE being signed by Intel, but it
should be more or less transparent to user code if it happens.
