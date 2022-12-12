Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4908FC4332F
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Dec 2022 18:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiLLSMM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Dec 2022 13:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiLLSL1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 12 Dec 2022 13:11:27 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D53178B3
        for <linux-sgx@vger.kernel.org>; Mon, 12 Dec 2022 10:09:51 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id s7so12901462plk.5
        for <linux-sgx@vger.kernel.org>; Mon, 12 Dec 2022 10:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=caT/eR3o2xI61xv4gQNQ+fDkRVtZB1sOkBNJmlEN+N4=;
        b=btZ4GA2g/VsRjxBZWyd9Ot4NYl23XggbHAYppoWAJmTxlei8M5/a+b75/69vjs6/GH
         I6tP0ipoDef613AM61HoV+CINKngTjD8WS0TtXzjvi7PemuFIO0aVViEu8P6/zlMroeA
         /rz2PU13KL9/wCcPniQNnwBMvXDHGjycV7BnTq/mTjEiO803KNc18d/0d7ajvdY3QB7c
         0dxIjjg5xtkMMm5gLHj3U0CnOt1GX8A52AptPekUmyPv2lyy1JN1gm/Yf/39hMlDWIAm
         iDow4z0quQ16cubZl80/hIZjTver2Aez811DpWbpe/dWEi1fggZISJ8ob8bsgCwH30Wl
         Vy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=caT/eR3o2xI61xv4gQNQ+fDkRVtZB1sOkBNJmlEN+N4=;
        b=aYNUC1qPy3wW2d37x9JUBPPFyARymwEzuGJGJsJEvSoRkKda/TZIo+1plkmWkaf1CQ
         Kf2GpvkjwdyRXZKvI7x0B1hFo1zfzXrfjGdZKQ3wYoARKscUqXU6pwpaLOFvKydYb++0
         5hPk6wYRVSunAekY+AXLHP1+Tp2AjeWlcZ/R5F/IyuIdbtbuuExV54bXkn7FkaxdD5Eb
         FTujlZ4TWyr3vsdXJ6VKBvnUr0edaSXo5iweBf8qGkVgfj2zVi4KZH63Ivc+w3tQ/50m
         NVlYe57cvxIHxjs4FKHhRa94s7fAz0F6xNLBFXQZ+Wq+P7laHMMRR4cXkIuP9L98fjQu
         KPQw==
X-Gm-Message-State: ANoB5pleCkQKcYTtn9b3qvNURIvotjaGEYCseHFSZQtdoYgcmB8JwHrR
        LRReiMitP7bT+McEKWIMUPNkWw==
X-Google-Smtp-Source: AA0mqf7zO/WZ6W2GV+EwOLWI4vx4kth8/QRN5S0b70Tpme+OTbmVntr3N2mA7+gmAJy9/GblRagCKg==
X-Received: by 2002:a17:90b:3b86:b0:218:84a0:65eb with SMTP id pc6-20020a17090b3b8600b0021884a065ebmr813368pjb.1.1670868583486;
        Mon, 12 Dec 2022 10:09:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ep11-20020a17090ae64b00b00210c84b8ae5sm5717900pjb.35.2022.12.12.10.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 10:09:43 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:09:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        dave.hansen@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        zhiquan1.li@intel.com
Subject: Re: [PATCH v2 14/18] x86/sgx: Add EPC OOM path to forcefully reclaim
 EPC
Message-ID: <Y5duYxIHtSpK1qkj@google.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-15-kristen@linux.intel.com>
 <Y5IBCOuF8X7jEK3+@kernel.org>
 <cb5abce531c1b14118de419ba68c2a501b016873.camel@linux.intel.com>
 <e5aff02b-713c-ccd8-7211-d07ff6d7adb2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5aff02b-713c-ccd8-7211-d07ff6d7adb2@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 09, 2022, Dave Hansen wrote:
> On 12/9/22 08:05, Kristen Carlson Accardi wrote:
> > Aside from that though, I don't think that killing enclaves makes sense
> > outside the context of cgroup limits. 
> 
> I think it makes a lot of sense in theory.  Whatever situation we get
> into with a cgroup's EPC we can also get into with the whole system's EPC.
> 
> *But*, it's orders of magnitude harder to hit on the whole system.

...

> If someone wants to extend this OOM support to system-wide EPC later, then go
> ahead.  But, I don't think it makes a lot of sense to invert this series for
> it.

+1 from the peanut gallery.  With VMM EPC oversubscription suport, no sane VMM
will oversubscribe VEPC pages.  And for VA pages, supporting swap of VA pages is
likely a more userspace-friendly approach if system-wide EPC OOM is a concern.
