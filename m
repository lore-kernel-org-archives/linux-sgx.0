Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F82020DE8
	for <linux-sgx@vger.kernel.org>; Sat, 29 Jun 2024 17:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719683271; cv=none; b=myWJ9BLgzRXPWnWllSbK9XjLWZlmEfur5M8rgX11AliR1wQWzImLvtB2Hoq6imy7khstufbp4kYTc+utVgY+6ebCSk8I5i8lQXFyHaS9hj+0FHrrYk7nnmSQqODj896jFUIT8j6Zv5HI9qQ73sCB4hvXnsEhAs4fdXRsuk9zn1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719683271; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To; b=dyNFg3doA4xtuR2+FT2t//kePBs++dbAnAAiAUkBUX1G90Q5oVQDPCaf4m4V7cp5jxB+nix8EwWeu9JXn81WNjr6zV5SuVaqgumkr5HUJ0dpAD7+HlcT1uTfg1J21h/SLOmxU9vJlhIyVK+ABY8+aDbdUzY71NU6TLTplAjJTe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danmerino.com; spf=none smtp.mailfrom=danmerino.com; dkim=pass (2048-bit key) header.d=danmerino-com.20230601.gappssmtp.com header.i=@danmerino-com.20230601.gappssmtp.com header.b=VJEp4Pbr; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danmerino.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=danmerino.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danmerino-com.20230601.gappssmtp.com header.i=@danmerino-com.20230601.gappssmtp.com header.b="VJEp4Pbr"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7163489149eso1149879a12.1
        for <linux-sgx@vger.kernel.org>; Sat, 29 Jun 2024 10:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=danmerino-com.20230601.gappssmtp.com; s=20230601; t=1719683269; x=1720288069; darn=vger.kernel.org;
        h=to:message-id:subject:date:mime-version:from
         :content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=VJEp4PbrP42lIyrdjERUbfL8VJuAIla5JxRGqPxt4CsA7yc9mGAUnlxwsgiHnginsz
         fG1KAeo7usOFlyJs1YQR9IqYDP+5txa9qgU1inIaNVfky6/GVkfjtQkMOX065ByTTt/i
         YEap5xa+3HjIPJFvUrsPoQgC6Lux/t0AmjXfYmr5VJsWBH2jmMVQaTDdIWUBKgf17GlN
         306KLL7fraCnwuHQcLD6e0WqELcmzdyeY3XYG0v6YlMYJKLVxhhcprfJ1202CDREPqPi
         GTcKzd+NqbEkvnUacRS1aqujkvXWF4Orj/bc1CX7QY61DGumK0SybpOJ043bOiYCpqb8
         Ucvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719683269; x=1720288069;
        h=to:message-id:subject:date:mime-version:from
         :content-transfer-encoding:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=RuT2FMWXbaUQc1mC1lns8z+lfdsrObK/Ay0xLEZxNbHnI4N6MaD7nMnDE+ZfXyHjx3
         7NZgQxZywTMCXWKLn0D03rjVq8W9m7ZLx6j4MkGT72s8Hucul0ahTOxqOxhTE9aw1j20
         kkYDVXrnT6+FxqDCC5iWIQg21gHgFX65G0AG1yWn1iOIyJuHjOYLIsDoM5IzFkVHWh/f
         v5XbSkwAg+YORTHEUEaz1eXCxqhSlFZOpOwZ85SQ4Eyzktz5OON04q9RXIxKDGwq/vii
         pOQn9QyJ2fLWS3d4jDaxUQx2YYKRRnPQf/rs96nVgwpnJNy702bE7GdjMs9VoJhiXCoA
         26rg==
X-Gm-Message-State: AOJu0Yzg5mGtz8lfDmVspTFs6YU6K2kP9T24UtK2TpicxD46+Qp9L4Ut
	kJG3gC2W8rJn7kpCpI41Zug681ycYjJgsQSyIsuEkMnpQ5vIxhPh6mVidB3Pa437Mw2/82W6TS4
	0
X-Google-Smtp-Source: AGHT+IEgIkeGrO/ctokBi3b1diB85q7krsSyjjL5SJueXUC9mGwWMJhOsHlaCgxxFL3H07UQ37yWFg==
X-Received: by 2002:a05:6a20:849b:b0:1be:c86e:7a4f with SMTP id adf61e73a8af0-1bef62453dfmr1636755637.54.1719683269017;
        Sat, 29 Jun 2024 10:47:49 -0700 (PDT)
Received: from smtpclient.apple ([2605:8d80:402:ea33:131:966c:ef37:e618])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7080256bf09sm3526249b3a.66.2024.06.29.10.47.48
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 10:47:48 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Dan Merino <dan@danmerino.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Date: Sat, 29 Jun 2024 10:47:37 -0700
Subject: Sub
Message-Id: <6B222F59-421B-4CCB-A987-0C5814962CCD@danmerino.com>
To: linux-sgx@vger.kernel.org
X-Mailer: iPhone Mail (21F90)


