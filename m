Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2844222DFA0
	for <linux-sgx@vger.kernel.org>; Mon, 10 Mar 2025 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741621198; cv=none; b=ntNX2Zvsa9pPNo9lkw7dnu6CI/iER+r2uXj3GMGwNGzCNnAro7C2PQYFR9wFMKOf9oitMbOa1g8q/mccvh7z7bEg+oeFV4W1WHbWiIl4cLz+zszwxRCzWSg3b8E9NP+1aD0Ivpzhc9XGtjrHKakvI3vTcFoIn84ff+AwO/MSoug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741621198; c=relaxed/simple;
	bh=UgKyEekB99QTYNP4fJFy3O5FfG+351jcDbaPpf+tBa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EVwzWL0YuDR17fYyTdzcJOIF4Qf6lzmzJL9159NXdimu7TQDYsl5cMXxzWmXZoDBHe2MQPtTYnfqEFXWaHisoHSQ/kI3kP6oTWERmUIrXWTtaprjAqYFOA7eff48Yvyac2TJwtcH516qR6FMk1Oj7jenGl/UBUoQxN7JjKxqW9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=by9Xr4kO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="by9Xr4kO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741621195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgKyEekB99QTYNP4fJFy3O5FfG+351jcDbaPpf+tBa0=;
	b=by9Xr4kOBgfeO+4/JLxUKaRBVmM1buKYBtLM7Sed2LSdmcCYL4emOol/sEAQ4CBNlo/9vW
	tS7dJaDGtrKsqfQknqq6Y5z5kqNF9rhUjTdwvVUPY5Ph52Bsw2wXEvlMPud35jIsJXRLXT
	qGrd1jUdzEhj8ziqYP2QMZOwMJubHAE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-QGa0Ie2HPUKKZXw5wVrhtQ-1; Mon, 10 Mar 2025 11:39:55 -0400
X-MC-Unique: QGa0Ie2HPUKKZXw5wVrhtQ-1
X-Mimecast-MFC-AGG-ID: QGa0Ie2HPUKKZXw5wVrhtQ_1741621194
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-54996475915so1293237e87.0
        for <linux-sgx@vger.kernel.org>; Mon, 10 Mar 2025 08:39:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741621193; x=1742225993;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UgKyEekB99QTYNP4fJFy3O5FfG+351jcDbaPpf+tBa0=;
        b=Xdagpvsz4nXRYn7/Gr2TUTjA8BOScMe00anzPRGF+qKRkPC4+Sb8pvChI5pmNm7EmZ
         wNJNi5VFfvVTTbPqSME7+CaSoYh/Rkbnd3mBMSMTlWUjyvOB0ka7VJzGl5knPBIeadS1
         qdWSnfB8ayvItbTawXQryfJMSzG8fTj4DC8zPW0pPknQ3Ip51zGJkGo+mhVRTOjCO/oW
         PBjF/n5dabYnfzIoUzc09y/2bfUbE2YD4V7I8aXLdQPXcq3cXl1ZeUe6/jE6+m0rxqri
         2whNXXKmTg51ye8fP8RkeQqn6SmrOtiAvWpQnbyZe6hFVT4z9P35GWf8P2OkU8jrKJt0
         eVlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnz0FHOy0rJuNqwiME53Q3WJcmtAyG3b8+0L6nROM58OQ9MeuTW2dztgUytPt2NUulrbI1y8B5gbY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4BsBHH8JJexAtb+bi0lSdVCmwGPnw9Rv9vFfCzmuzaOU4H4I8
	MeF0aZ3jm+AuxiV7E9VD1J1U2rH8r/S36Hfz7xOgUuDJ3T8meO3eJTEEdTih4zzUm75KgRoekq0
	ZBfViC65xeHfLitFBJy56fIDKMSjq0kTZtQDjASgBIar2V8+uhBoNwdITKbgc2dPnMOlL60yMEC
	8YfGQypxC+YMKhKwN2uhjxuj7hjJ/8Czey
X-Gm-Gg: ASbGncufkcF8BP09pAqs5N8cPixt+DSVkL5MglQx9FiuCohmVyZrUeMTYil1Ce5kx5A
	3jFB7270Y8B9JsPTWNNlgMv+Tw1LRHyF9IgPtQ1PdGxjSgBW8PK00wcqrYfGvZofTePCLh4ZZ
X-Received: by 2002:a05:6512:1242:b0:549:905c:c3b9 with SMTP id 2adb3069b0e04-54990e27382mr4079646e87.9.1741621192628;
        Mon, 10 Mar 2025 08:39:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8r6MosJU6bCJ7fTaIje1/2x6BKstRJc7xapTbeccshOaGXSyueQIe9iWTKagYPOWCFUMq4FUPddHh5u9bO0s=
X-Received: by 2002:a05:6512:1242:b0:549:905c:c3b9 with SMTP id
 2adb3069b0e04-54990e27382mr4079607e87.9.1741621190775; Mon, 10 Mar 2025
 08:39:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250309172215.21777-2-vdronov@redhat.com> <c21c89d29f006945b6be7624599809b36574530e.camel@intel.com>
 <Z86l9WiiP_4bFC8q@gmail.com> <d91942f7782fe1e1f1491de86d60bb14b2d5e781.camel@intel.com>
In-Reply-To: <d91942f7782fe1e1f1491de86d60bb14b2d5e781.camel@intel.com>
From: Vladis Dronov <vdronov@redhat.com>
Date: Mon, 10 Mar 2025 16:39:39 +0100
X-Gm-Features: AQ5f1JppX7aB_ARebLW62l8EsNs6FyfTqyQsbqGxChoyav7O61KfV8THxwKV9Zo
Message-ID: <CAMusb+RJh-xvuFkNJoeVY_28W5_GR0pn+=gw3hLzi4rhdAKaXg@mail.gmail.com>
Subject: Re: [PATCH -v3] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not enabled
To: "Huang, Kai" <kai.huang@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yRckRjn3UnWtQDfeNYx598gJ92EpXywkzcFA6MRtS1w_1741621194
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi, Jarkko, Kai,

Thanks a ton for your suggestions and edits!

Hi, Ingo,

Thank you many tons for your help and attention to this small
patch and a TIP submission! I wasn't expecting such an...
immediate response to my small suggestion, honestly.

Best regards,
Vladis

